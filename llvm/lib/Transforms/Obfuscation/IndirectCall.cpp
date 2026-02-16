#include "llvm/IR/Constants.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Obfuscation/IndirectCall.h"
#include "llvm/Transforms/Obfuscation/ObfuscationOptions.h"
#include "llvm/Transforms/Obfuscation/Utils.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/IR/Module.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/APInt.h"
#include "llvm/Support/RandomNumberGenerator.h"
#include "llvm/TargetParser/Triple.h"

#include <random>

#define DEBUG_TYPE "icall"

using namespace llvm;

namespace {
struct IndirectCall : public FunctionPass {
  static char         ID;
  ObfuscationOptions *ArgsOptions;

  DenseMap<Function *, SmallPtrSet<CallInst *, 8>> FunctionCallSites;
  DenseMap<Function *, SmallPtrSet<Function *, 8>> FunctionCallees;

  std::vector<Constant *>        Callees;
  DenseMap<Constant *, unsigned> CalleeIndex;
  // 63 - 32====31 - 0
  //  Mask=======Key
  DenseMap<Constant *, uint64_t>   CalleeKeys;
  SmallVector<GlobalVariable *, 8> CalleePageTable;
  std::mt19937_64                  RNG;
  uint64_t                         PtrEncKey = 0;

  bool RunOnFuncChanged = false;

  IndirectCall(ObfuscationOptions *argsOptions) : FunctionPass(ID) {
    this->ArgsOptions = argsOptions;
    uint64_t seed = 0;
    if (auto errorCode = llvm::getRandomBytes(&seed, sizeof(seed))) {
      llvm::report_fatal_error(
          StringRef("Failed to get random bytes for page table generation") +
          errorCode.message());
    }

    RNG = std::mt19937_64(seed);
  }

  StringRef getPassName() const override {
    return {"IndirectCall"};
  }

  void NumberCallees(Module &M) {
    for (auto &F : M) {
      if (F.isIntrinsic()) {
        continue;
      }

      for (auto &BB : F) {
        for (auto &I : BB) {
          if (auto CI = dyn_cast<CallInst>(&I)) {
            auto CB = dyn_cast<CallBase>(&I);
            auto Callee = CB->getCalledFunction();
            if (Callee == nullptr) {
              Callee = dyn_cast<Function>(
                  CB->getCalledOperand()->stripPointerCasts());
              if (!Callee) {
                continue;
              }
            }
            if (Callee->isIntrinsic()) {
              continue;
            }

            FunctionCallSites[&F].insert(CI);
            FunctionCallees[&F].insert(Callee);

            if (CalleeKeys.count(Callee) == 0) {
              Callees.push_back(Callee);
              CalleeKeys[Callee] = RNG();
            }
          }
        }
      }
    }
  }

  bool doInitialization(Module &M) override {
    CalleeIndex.clear();
    FunctionCallSites.clear();
    FunctionCallees.clear();
    Callees.clear();
    CalleePageTable.clear();
    CalleeKeys.clear();

    NumberCallees(M);
    if (!Callees.size()) {
      return false;
    }

    PtrEncKey = RNG();

    CreatePageTableArgs createPageTableArgs;
    createPageTableArgs.CountLoop = 1;
    createPageTableArgs.GVNamePrefix = M.getName().str() + "_IndirectCallee";
    createPageTableArgs.RNG = &RNG;
    createPageTableArgs.M = &M;
    createPageTableArgs.Objects = &Callees;
    createPageTableArgs.IndexMap = &CalleeIndex;
    createPageTableArgs.ObjectKeys = &CalleeKeys;
    createPageTableArgs.OutPageTable = &CalleePageTable;
    createPageTableArgs.PtrEncKey = PtrEncKey;

    createPageTable(createPageTableArgs);
    return false;
  }

  bool runOnFunction(Function &Fn) override {
    const auto opt = ArgsOptions->toObfuscate(ArgsOptions->iCallOpt(), &Fn);
    if (!opt.isEnabled()) {
      return false;
    }

    auto &M = *Fn.getParent();

    if (Callees.empty()) {
      return false;
    }
    const auto &CallSites = FunctionCallSites[&Fn];
    auto &      FuncCalleesSet = FunctionCallees[&Fn];

    if (CallSites.empty() || FuncCalleesSet.empty()) {
      return false;
    }

    std::vector<Constant *>        FuncCallees;
    DenseMap<Constant *, uint64_t> FuncKeys;
    for (auto callee : FuncCalleesSet) {
      FuncCallees.push_back(callee);
      FuncKeys[callee] = RNG();
    }

    SmallVector<GlobalVariable *, 8> FuncCalleePageTable;
    DenseMap<Constant *, unsigned>   FuncCalleeIndex;

    if (opt.level()) {
      CreatePageTableArgs createPageTableArgs;
      createPageTableArgs.CountLoop = opt.level();
      createPageTableArgs.GVNamePrefix =
          M.getName().str() + Fn.getName().str() + "_IndirectCallee";
      createPageTableArgs.RNG = &RNG;
      createPageTableArgs.M = &M;
      createPageTableArgs.Objects = &FuncCallees;
      createPageTableArgs.IndexMap = &CalleeIndex;
      createPageTableArgs.ObjectKeys = &FuncKeys;
      createPageTableArgs.OutPageTable = &FuncCalleePageTable;

      enhancedPageTable(createPageTableArgs, &FuncCalleeIndex);
    }

    for (auto CI : CallSites) {

      CallBase *CB = CI;

      Function *Callee = CB->getCalledFunction();
      if (Callee == nullptr) {
        Callee = dyn_cast<
          Function>(CB->getCalledOperand()->stripPointerCasts());
        if (!Callee) {
          continue;
        }
      }

      BuildDecryptArgs buildDecrypt;
      buildDecrypt.FuncLoopCount = opt.level();
      buildDecrypt.NextIndex = opt.level()
                                 ? FuncCalleeIndex[Callee]
                                 : CalleeIndex[Callee];
      buildDecrypt.NextIndexValue = nullptr;
      buildDecrypt.Fn = &Fn;
      buildDecrypt.InsertBefore = CB;
      buildDecrypt.LoadTy = Callee->getType();
      buildDecrypt.ModulePageTable = &CalleePageTable;
      buildDecrypt.FuncPageTable = &FuncCalleePageTable;
      buildDecrypt.ModuleKey = CalleeKeys[Callee];
      buildDecrypt.FuncKey = FuncKeys[Callee];
      buildDecrypt.PtrEncKey = PtrEncKey;
      Triple T(M.getTargetTriple());
      buildDecrypt.PtrAuthKey = T.isAArch64() ? 0 : -1; // IA for code pointers
      buildDecrypt.PtrAuthDisc = 0;

      auto FnPtr = buildPageTableDecryptIR(buildDecrypt);
      FnPtr->setName("Call_" + Callee->getName());
      CB->setCalledOperand(FnPtr);
    }

    RunOnFuncChanged = true;
    return true;
  }

  bool doFinalization(Module &M) override {
    if (!RunOnFuncChanged || CalleePageTable.empty()) {
      return false;
    }
    for (auto calleePage : CalleePageTable) {
      appendToCompilerUsed(M, {calleePage});
    }
    return true;
  }

};
} // anonymous namespace

char IndirectCall::ID = 0;

FunctionPass *llvm::createIndirectCallPass(ObfuscationOptions *argsOptions) {
  return new IndirectCall(argsOptions);
}

INITIALIZE_PASS(IndirectCall, "icall", "Enable IR Indirect Call Obfuscation",
                false, false)