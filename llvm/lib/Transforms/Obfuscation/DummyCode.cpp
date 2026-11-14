#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/Alignment.h"
#include "llvm/Support/RandomNumberGenerator.h"
#include "llvm/Transforms/Obfuscation/DummyCode.h"
#include "llvm/Transforms/Obfuscation/ObfuscationOptions.h"

#include <random>

#define DEBUG_TYPE "dummycode"

using namespace llvm;

namespace {

struct DummyCode : public FunctionPass {
  static char ID;
  ObfuscationOptions *ArgsOptions;
  std::mt19937_64 RNG;
  bool Changed = false;

  bool doFinalization(Module &M) override {
    if (!Changed)
      return false;
    // Invalidate caller summaries too, including indirect call sites.
    for (Function &F : M) {
      if (F.isDeclaration())
        continue;
      F.removeFnAttr(Attribute::Memory);
      F.removeFnAttr(Attribute::Speculatable);
      F.removeFnAttr(Attribute::NoSync);
      for (BasicBlock &BB : F)
        for (Instruction &I : BB)
          if (auto *Call = dyn_cast<CallBase>(&I)) {
            if (Call->getCalledFunction() && Call->getCalledFunction()->isIntrinsic())
              continue;
            Call->removeFnAttr(Attribute::Memory);
            Call->removeFnAttr(Attribute::Speculatable);
            Call->removeFnAttr(Attribute::NoSync);
          }
    }
    Changed = false;
    return true;
  }

  DummyCode(ObfuscationOptions *argsOptions) : FunctionPass(ID) {
    this->ArgsOptions = argsOptions;
    uint64_t seed = 0;
    if (auto errorCode = llvm::getRandomBytes(&seed, sizeof(seed))) {
      llvm::report_fatal_error(
          StringRef("Failed to get random bytes for dummy code generation") +
          errorCode.message());
    }

    RNG = std::mt19937_64(seed);
  }

  StringRef getPassName() const override {
    return {"DummyCode"};
  }

  bool runOnFunction(Function &F) override;

  Value *keyValue(IRBuilder<> &IRB, Module &M, IntegerType *IntPtrTy);
  Value *seedValue(IRBuilder<> &IRB, Function &F, IntegerType *IntPtrTy,
                   Value *Key);
  Value *scramble(IRBuilder<> &IRB, Value *Input, IntegerType *IntPtrTy,
                  unsigned Count);
  Value *alwaysTrue(IRBuilder<> &IRB, Value *Input);
  Value *loopCount(IRBuilder<> &IRB, Value *Seed, IntegerType *IntPtrTy,
                   unsigned Minimum, unsigned Span);
  Value *emitKernel(IRBuilder<> &IRB, Value *Seed, IntegerType *IntPtrTy,
                    BasicBlock *InsertBefore);
  Value *emitFibonacci(IRBuilder<> &IRB, Value *Seed, IntegerType *IntPtrTy,
                       BasicBlock *InsertBefore);
  Value *emitMatrixFibonacci(IRBuilder<> &IRB, Value *Seed,
                             IntegerType *IntPtrTy, BasicBlock *InsertBefore);
  Value *emitCollatz(IRBuilder<> &IRB, Value *Seed, IntegerType *IntPtrTy,
                     BasicBlock *InsertBefore);
  Value *emitGcd(IRBuilder<> &IRB, Value *Seed, IntegerType *IntPtrTy,
                 BasicBlock *InsertBefore);
  Value *emitModExp(IRBuilder<> &IRB, Value *Seed, IntegerType *IntPtrTy,
                    BasicBlock *InsertBefore);
};
} // anonymous namespace

// (input * (input + 1)) is always even, so its lowest bit is always zero.
// The optimizer cannot prove that for a value with unknown low bits, and the
// scramble keeps the computation feeding this predicate alive.
Value *DummyCode::alwaysTrue(IRBuilder<> &IRB, Value *Input) {
  auto *IntTy = cast<IntegerType>(Input->getType());
  Value *Next = IRB.CreateAdd(Input, ConstantInt::get(IntTy, 1), "dummy.odd");
  Value *Product = IRB.CreateMul(Input, Next, "dummy.odd");
  Value *Lowest = IRB.CreateAnd(Product, ConstantInt::get(IntTy, 1),
                                "dummy.odd");
  return IRB.CreateICmpEQ(Lowest, ConstantInt::get(IntTy, 0), "dummy.route");
}

Value *DummyCode::scramble(IRBuilder<> &IRB, Value *Input,
                           IntegerType *IntPtrTy, unsigned Count) {
  Value *Result = Input;
  for (unsigned Index = 0; Index != Count; ++Index) {
    switch (RNG() % 4) {
    case 0:
      Result = IRB.CreateAdd(Result, ConstantInt::get(IntPtrTy, RNG()),
                             "dummy.junk");
      break;
    case 1:
      Result = IRB.CreateMul(Result, ConstantInt::get(IntPtrTy, RNG() | 1),
                             "dummy.junk");
      break;
    case 2:
      Result = IRB.CreateXor(Result, ConstantInt::get(IntPtrTy, RNG()),
                             "dummy.junk");
      break;
    default:
      Result = IRB.CreateSub(Result, ConstantInt::get(IntPtrTy, RNG()),
                             "dummy.junk");
      break;
    }
  }
  return Result;
}

Value *DummyCode::loopCount(IRBuilder<> &IRB, Value *Seed,
                            IntegerType *IntPtrTy, unsigned Minimum,
                            unsigned Span) {
  Value *Mask = ConstantInt::get(IntPtrTy, Span - 1);
  return IRB.CreateAdd(IRB.CreateAnd(Seed, Mask),
                       ConstantInt::get(IntPtrTy, Minimum), "dummy.count");
}

// The optimizer cannot reason about the contents of a volatile load, so this
// keeps the guards from ever being folded into a constant condition.
Value *DummyCode::keyValue(IRBuilder<> &IRB, Module &M, IntegerType *IntPtrTy) {
  auto *Key = new GlobalVariable(M, IntPtrTy, false, GlobalValue::PrivateLinkage,
                                 ConstantInt::get(IntPtrTy, RNG()), "");
  Key->setAlignment(M.getDataLayout().getABITypeAlign(IntPtrTy));
  // Freeze so a poison or undef value cannot make the guard undefined.
  return IRB.CreateFreeze(IRB.CreateLoad(IntPtrTy, Key, true, "dummy.seed"),
                          "dummy.seed");
}

Value *DummyCode::seedValue(IRBuilder<> &IRB, Function &F,
                            IntegerType *IntPtrTy, Value *Key) {
  for (Argument &Arg : F.args()) {
    Type *Ty = Arg.getType();
    if (Ty->isIntegerTy() && Ty->getIntegerBitWidth() >= 8) {
      return IRB.CreateFreeze(
          IRB.CreateIntCast(&Arg, IntPtrTy, false, "dummy.seed"), "dummy.seed");
    }
    if (Ty->isPointerTy() &&
        !F.getParent()->getDataLayout().isNonIntegralPointerType(Ty)) {
      return IRB.CreateFreeze(
          IRB.CreatePtrToInt(&Arg, IntPtrTy, "dummy.seed"), "dummy.seed");
    }
  }
  return Key;
}

Value *DummyCode::emitFibonacci(IRBuilder<> &IRB, Value *Seed,
                                IntegerType *IntPtrTy,
                                BasicBlock *InsertBefore) {
  LLVMContext &Ctx = IRB.getContext();
  Function *F = IRB.GetInsertBlock()->getParent();
  Value *One = ConstantInt::get(IntPtrTy, 1);
  Value *Count = loopCount(IRB, Seed, IntPtrTy, 10, 32);
  Value *First =
      IRB.CreateAnd(Seed, ConstantInt::get(IntPtrTy, 0xff), "dummy.fib");
  Value *Second = IRB.CreateAdd(First, One, "dummy.fib");
  BasicBlock *Site = IRB.GetInsertBlock();

  BasicBlock *Header = BasicBlock::Create(Ctx, "dummy.fib", F, InsertBefore);
  BasicBlock *Body = BasicBlock::Create(Ctx, "dummy.fib", F, InsertBefore);
  BasicBlock *Latch = BasicBlock::Create(Ctx, "dummy.fib", F, InsertBefore);
  BasicBlock *Exit = BasicBlock::Create(Ctx, "dummy.fib", F, InsertBefore);
  IRB.CreateBr(Header);

  IRB.SetInsertPoint(Header);
  PHINode *Index = IRB.CreatePHI(IntPtrTy, 2, "dummy.fib");
  PHINode *Low = IRB.CreatePHI(IntPtrTy, 2, "dummy.fib");
  PHINode *High = IRB.CreatePHI(IntPtrTy, 2, "dummy.fib");
  Index->addIncoming(ConstantInt::get(IntPtrTy, 0), Site);
  Low->addIncoming(First, Site);
  High->addIncoming(Second, Site);
  IRB.CreateCondBr(IRB.CreateICmpULT(Index, Count), Body, Exit);

  IRB.SetInsertPoint(Body);
  Value *Next = IRB.CreateAdd(Low, High, "dummy.fib");
  IRB.CreateBr(Latch);

  IRB.SetInsertPoint(Latch);
  Value *Step = IRB.CreateAdd(Index, One, "dummy.fib");
  IRB.CreateBr(Header);
  Index->addIncoming(Step, Latch);
  Low->addIncoming(High, Latch);
  High->addIncoming(Next, Latch);

  IRB.SetInsertPoint(Exit);
  return IRB.CreateXor(Low, High, "dummy.fib");
}

Value *DummyCode::emitMatrixFibonacci(IRBuilder<> &IRB, Value *Seed,
                                      IntegerType *IntPtrTy,
                                      BasicBlock *InsertBefore) {
  LLVMContext &Ctx = IRB.getContext();
  Function *F = IRB.GetInsertBlock()->getParent();
  Value *One = ConstantInt::get(IntPtrTy, 1);
  Value *Count = loopCount(IRB, Seed, IntPtrTy, 8, 16);
  Value *InitM01 =
      IRB.CreateOr(One, IRB.CreateAnd(Seed, One, "dummy.mat"), "dummy.mat");
  BasicBlock *Site = IRB.GetInsertBlock();

  BasicBlock *Header = BasicBlock::Create(Ctx, "dummy.mat", F, InsertBefore);
  BasicBlock *Body = BasicBlock::Create(Ctx, "dummy.mat", F, InsertBefore);
  BasicBlock *Latch = BasicBlock::Create(Ctx, "dummy.mat", F, InsertBefore);
  BasicBlock *Exit = BasicBlock::Create(Ctx, "dummy.mat", F, InsertBefore);
  IRB.CreateBr(Header);

  IRB.SetInsertPoint(Header);
  PHINode *Index = IRB.CreatePHI(IntPtrTy, 2, "dummy.mat");
  PHINode *M00 = IRB.CreatePHI(IntPtrTy, 2, "dummy.mat");
  PHINode *M01 = IRB.CreatePHI(IntPtrTy, 2, "dummy.mat");
  PHINode *M10 = IRB.CreatePHI(IntPtrTy, 2, "dummy.mat");
  PHINode *M11 = IRB.CreatePHI(IntPtrTy, 2, "dummy.mat");
  Index->addIncoming(ConstantInt::get(IntPtrTy, 0), Site);
  M00->addIncoming(One, Site);
  M01->addIncoming(InitM01, Site);
  M10->addIncoming(One, Site);
  M11->addIncoming(ConstantInt::get(IntPtrTy, 0), Site);
  IRB.CreateCondBr(IRB.CreateICmpULT(Index, Count), Body, Exit);

  IRB.SetInsertPoint(Body);
  Value *N00 = IRB.CreateAdd(IRB.CreateMul(M00, M00, "dummy.mat"),
                             IRB.CreateMul(M01, M10, "dummy.mat"),
                             "dummy.mat");
  Value *N01 = IRB.CreateAdd(IRB.CreateMul(M00, M01, "dummy.mat"),
                             IRB.CreateMul(M01, M11, "dummy.mat"),
                             "dummy.mat");
  Value *N10 = IRB.CreateAdd(IRB.CreateMul(M10, M00, "dummy.mat"),
                             IRB.CreateMul(M11, M10, "dummy.mat"),
                             "dummy.mat");
  Value *N11 = IRB.CreateAdd(IRB.CreateMul(M10, M01, "dummy.mat"),
                             IRB.CreateMul(M11, M11, "dummy.mat"),
                             "dummy.mat");
  IRB.CreateBr(Latch);

  IRB.SetInsertPoint(Latch);
  Value *Step = IRB.CreateAdd(Index, One, "dummy.mat");
  IRB.CreateBr(Header);
  Index->addIncoming(Step, Latch);
  M00->addIncoming(N00, Latch);
  M01->addIncoming(N01, Latch);
  M10->addIncoming(N10, Latch);
  M11->addIncoming(N11, Latch);

  IRB.SetInsertPoint(Exit);
  return IRB.CreateXor(M00, M11, "dummy.mat");
}

Value *DummyCode::emitCollatz(IRBuilder<> &IRB, Value *Seed,
                              IntegerType *IntPtrTy, BasicBlock *InsertBefore) {
  LLVMContext &Ctx = IRB.getContext();
  Function *F = IRB.GetInsertBlock()->getParent();
  Value *One = ConstantInt::get(IntPtrTy, 1);
  Value *Three = ConstantInt::get(IntPtrTy, 3);
  Value *Count = loopCount(IRB, Seed, IntPtrTy, 12, 32);
  Value *Start = IRB.CreateOr(Seed, One, "dummy.odd");
  BasicBlock *Site = IRB.GetInsertBlock();

  BasicBlock *Header = BasicBlock::Create(Ctx, "dummy.col", F, InsertBefore);
  BasicBlock *Body = BasicBlock::Create(Ctx, "dummy.col", F, InsertBefore);
  BasicBlock *Latch = BasicBlock::Create(Ctx, "dummy.col", F, InsertBefore);
  BasicBlock *Exit = BasicBlock::Create(Ctx, "dummy.col", F, InsertBefore);
  IRB.CreateBr(Header);

  IRB.SetInsertPoint(Header);
  PHINode *Index = IRB.CreatePHI(IntPtrTy, 2, "dummy.col");
  PHINode *Current = IRB.CreatePHI(IntPtrTy, 2, "dummy.col");
  Index->addIncoming(ConstantInt::get(IntPtrTy, 0), Site);
  Current->addIncoming(Start, Site);
  IRB.CreateCondBr(IRB.CreateICmpULT(Index, Count), Body, Exit);

  IRB.SetInsertPoint(Body);
  Value *IsOdd = IRB.CreateICmpNE(IRB.CreateAnd(Current, One, "dummy.col"),
                                  ConstantInt::get(IntPtrTy, 0), "dummy.col");
  Value *Grow = IRB.CreateAdd(IRB.CreateMul(Current, Three, "dummy.col"), One,
                              "dummy.col");
  Value *Shrink = IRB.CreateLShr(Current, One, "dummy.col");
  Value *Next = IRB.CreateSelect(IsOdd, Grow, Shrink, "dummy.col");
  IRB.CreateBr(Latch);

  IRB.SetInsertPoint(Latch);
  Value *Step = IRB.CreateAdd(Index, One, "dummy.col");
  IRB.CreateBr(Header);
  Index->addIncoming(Step, Latch);
  Current->addIncoming(Next, Latch);

  IRB.SetInsertPoint(Exit);
  return IRB.CreateXor(Current, Start, "dummy.col");
}

Value *DummyCode::emitGcd(IRBuilder<> &IRB, Value *Seed, IntegerType *IntPtrTy,
                          BasicBlock *InsertBefore) {
  LLVMContext &Ctx = IRB.getContext();
  Function *F = IRB.GetInsertBlock()->getParent();
  Value *One = ConstantInt::get(IntPtrTy, 1);
  Value *Count = loopCount(IRB, Seed, IntPtrTy, 12, 32);
  Value *Left = IRB.CreateOr(Seed, One, "dummy.gcd");
  Value *Right = IRB.CreateOr(
      IRB.CreateLShr(Seed, ConstantInt::get(IntPtrTy, 7),
                     "dummy.gcd"),
      ConstantInt::get(IntPtrTy, 3), "dummy.gcd");
  BasicBlock *Site = IRB.GetInsertBlock();

  BasicBlock *Header = BasicBlock::Create(Ctx, "dummy.gcd", F, InsertBefore);
  BasicBlock *Body = BasicBlock::Create(Ctx, "dummy.gcd", F, InsertBefore);
  BasicBlock *Latch = BasicBlock::Create(Ctx, "dummy.gcd", F, InsertBefore);
  BasicBlock *Exit = BasicBlock::Create(Ctx, "dummy.gcd", F, InsertBefore);
  IRB.CreateBr(Header);

  IRB.SetInsertPoint(Header);
  PHINode *Index = IRB.CreatePHI(IntPtrTy, 2, "dummy.gcd");
  PHINode *A = IRB.CreatePHI(IntPtrTy, 2, "dummy.gcd");
  PHINode *B = IRB.CreatePHI(IntPtrTy, 2, "dummy.gcd");
  Index->addIncoming(ConstantInt::get(IntPtrTy, 0), Site);
  A->addIncoming(Left, Site);
  B->addIncoming(Right, Site);
  IRB.CreateCondBr(IRB.CreateICmpULT(Index, Count), Body, Exit);

  IRB.SetInsertPoint(Body);
  Value *Remainder = IRB.CreateURem(A, B, "dummy.gcd");
  IRB.CreateBr(Latch);

  IRB.SetInsertPoint(Latch);
  Value *Step = IRB.CreateAdd(Index, One, "dummy.gcd");
  Value *Shifted = IRB.CreateOr(Remainder, One, "dummy.gcd");
  IRB.CreateBr(Header);
  Index->addIncoming(Step, Latch);
  A->addIncoming(B, Latch);
  B->addIncoming(Shifted, Latch);

  IRB.SetInsertPoint(Exit);
  return IRB.CreateXor(A, B, "dummy.gcd");
}

Value *DummyCode::emitModExp(IRBuilder<> &IRB, Value *Seed,
                             IntegerType *IntPtrTy, BasicBlock *InsertBefore) {
  LLVMContext &Ctx = IRB.getContext();
  Function *F = IRB.GetInsertBlock()->getParent();
  Value *One = ConstantInt::get(IntPtrTy, 1);
  Value *Count = loopCount(IRB, Seed, IntPtrTy, 10, 32);
  Value *Base = IRB.CreateOr(Seed, One, "dummy.exp");
  Value *Accumulator = IRB.CreateOr(
      IRB.CreateAnd(IRB.CreateLShr(Seed, ConstantInt::get(IntPtrTy, 3),
                                   "dummy.exp"),
                    ConstantInt::get(IntPtrTy, 0xffff), "dummy.exp"),
      One, "dummy.exp");
  Value *Modulus = ConstantInt::get(IntPtrTy, (RNG() | 1) & 0x7fffffff);
  BasicBlock *Site = IRB.GetInsertBlock();

  BasicBlock *Header = BasicBlock::Create(Ctx, "dummy.exp", F, InsertBefore);
  BasicBlock *Body = BasicBlock::Create(Ctx, "dummy.exp", F, InsertBefore);
  BasicBlock *Latch = BasicBlock::Create(Ctx, "dummy.exp", F, InsertBefore);
  BasicBlock *Exit = BasicBlock::Create(Ctx, "dummy.exp", F, InsertBefore);
  IRB.CreateBr(Header);

  IRB.SetInsertPoint(Header);
  PHINode *Index = IRB.CreatePHI(IntPtrTy, 2, "dummy.exp");
  PHINode *Acc = IRB.CreatePHI(IntPtrTy, 2, "dummy.exp");
  PHINode *Power = IRB.CreatePHI(IntPtrTy, 2, "dummy.exp");
  Index->addIncoming(ConstantInt::get(IntPtrTy, 0), Site);
  Acc->addIncoming(Accumulator, Site);
  Power->addIncoming(Base, Site);
  IRB.CreateCondBr(IRB.CreateICmpULT(Index, Count), Body, Exit);

  IRB.SetInsertPoint(Body);
  Value *NextAcc =
      IRB.CreateURem(IRB.CreateMul(Acc, Power, "dummy.exp"), Modulus,
                     "dummy.exp");
  Value *NextPower =
      IRB.CreateURem(IRB.CreateMul(Power, Power, "dummy.exp"), Modulus,
                     "dummy.exp");
  IRB.CreateBr(Latch);

  IRB.SetInsertPoint(Latch);
  Value *Step = IRB.CreateAdd(Index, One, "dummy.exp");
  IRB.CreateBr(Header);
  Index->addIncoming(Step, Latch);
  Acc->addIncoming(NextAcc, Latch);
  Power->addIncoming(NextPower, Latch);

  IRB.SetInsertPoint(Exit);
  return IRB.CreateXor(Acc, Power, "dummy.exp");
}

// Each build randomly selects one kernel, seed, trip count and modulus, so two
// builds of the same input do not share dummy code.
Value *DummyCode::emitKernel(IRBuilder<> &IRB, Value *Seed,
                             IntegerType *IntPtrTy, BasicBlock *InsertBefore) {
  switch (RNG() % 5) {
  case 0:
    return emitFibonacci(IRB, Seed, IntPtrTy, InsertBefore);
  case 1:
    return emitMatrixFibonacci(IRB, Seed, IntPtrTy, InsertBefore);
  case 2:
    return emitCollatz(IRB, Seed, IntPtrTy, InsertBefore);
  case 3:
    return emitGcd(IRB, Seed, IntPtrTy, InsertBefore);
  default:
    return emitModExp(IRB, Seed, IntPtrTy, InsertBefore);
  }
}

static bool canInsertRoute(BasicBlock &BB) {
  if (BB.isEHPad()) {
    return false;
  }
  Instruction *Term = BB.getTerminator();
  if (!Term || !(isa<BranchInst>(Term) || isa<ReturnInst>(Term) ||
                 isa<SwitchInst>(Term) || isa<UnreachableInst>(Term))) {
    return false;
  }
  for (Instruction &Inst : BB) {
    auto *Call = dyn_cast<CallBase>(&Inst);
    if (!Call) {
      continue;
    }
    if (Call->isMustTailCall()) {
      return false;
    }
    if (const Function *Callee = Call->getCalledFunction()) {
      if (Callee->getName().starts_with("llvm.experimental.deoptimize")) {
        return false;
      }
    }
  }
  return true;
}

bool DummyCode::runOnFunction(Function &F) {
  const auto Opt = ArgsOptions->toObfuscate(ArgsOptions->dummyOpt(), &F);
  if (!Opt.isEnabled() || F.empty() || F.isIntrinsic() ||
      F.isPresplitCoroutine() || F.hasPersonalityFn() ||
      F.hasFnAttribute(Attribute::Naked)) {
    return false;
  }

  Module &M = *F.getParent();
  LLVMContext &Ctx = F.getContext();
  auto *IntPtrTy = dyn_cast<IntegerType>(M.getDataLayout().getIntPtrType(Ctx));
  if (!IntPtrTy || IntPtrTy->getBitWidth() < 8) {
    return false;
  }

  SmallVector<BasicBlock *, 32> Targets;
  for (BasicBlock &BB : F) {
    if (canInsertRoute(BB)) {
      Targets.push_back(&BB);
    }
  }
  if (Targets.empty()) {
    return false;
  }

  IRBuilder<> Entry(&*F.getEntryBlock().getFirstInsertionPt());
  Value *Key = keyValue(Entry, M, IntPtrTy);
  Value *Base = seedValue(Entry, F, IntPtrTy, Key);
  Function *SideEffect =
      Intrinsic::getOrInsertDeclaration(&M, Intrinsic::sideeffect);

  for (BasicBlock *BB : Targets) {
    BasicBlock *Body = BB->splitBasicBlock(BB->getTerminator(), "dummy.body");
    BB->getTerminator()->eraseFromParent();

    IRBuilder<> IRB(BB);
    Value *Guard = scramble(IRB, Base, IntPtrTy, 2 + RNG() % 3);
    Guard = IRB.CreateXor(Guard, Key, "dummy.route");
    BasicBlock *Route = BasicBlock::Create(Ctx, "dummy.route", &F, Body);
    IRB.CreateCondBr(alwaysTrue(IRB, Guard), Body, Route);

    // The trailing stub carries a side effect so cleanup passes cannot
    // collapse the route chain into straight-line code.
    BasicBlock *Stub = BasicBlock::Create(Ctx, "dummy.stub", &F, Body);
    unsigned Count = Opt.level() + 1;
    for (unsigned Depth = 0; Depth != Count; ++Depth) {
      IRBuilder<> RouteIRB(Route);
      Value *Result = emitKernel(RouteIRB, Base, IntPtrTy, Body);
      Result = RouteIRB.CreateXor(Result, Key, "dummy.route");
      RouteIRB.CreateCall(SideEffect);
      BasicBlock *Next = Depth + 1 == Count
                             ? Stub
                             : BasicBlock::Create(Ctx, "dummy.route", &F, Body);
      RouteIRB.CreateCondBr(alwaysTrue(RouteIRB, Result), Body, Next);
      Route = Next;
    }

    IRBuilder<> StubIRB(Stub);
    StubIRB.CreateCall(SideEffect);
    StubIRB.CreateBr(Body);
  }

  Changed = true;
  return true;
}

char DummyCode::ID = 0;

FunctionPass *llvm::createDummyCodePass(ObfuscationOptions *argsOptions) {
  return new DummyCode(argsOptions);
}

INITIALIZE_PASS(DummyCode, "dummycode",
                "Enable IR Dummy Code Route Obfuscation", false, false)
