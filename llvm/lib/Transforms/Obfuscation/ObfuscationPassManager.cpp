#include "llvm/Transforms/Obfuscation/ObfuscationPassManager.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "llvm/Transforms/Obfuscation/ObfuscationOptions.h"
#include "llvm/IR/Module.h"


#define DEBUG_TYPE "ir-obfuscation"

using namespace llvm;

static cl::opt<bool>
EnableIRObfuscation("irobf", cl::init(false), cl::NotHidden,
                    cl::desc("Enable IR Code Obfuscation."),
                    cl::ZeroOrMore);
static cl::opt<bool>



EnableIndirectBr("irobf-indbr", cl::init(false), cl::NotHidden,
                 cl::desc("Enable IR Indirect Branch Obfuscation."),
                 cl::ZeroOrMore);
static cl::opt<uint32_t>
LevelIndirectBr("level-indbr", cl::init(0), cl::NotHidden,
  cl::desc("Set IR Indirect Branch Obfuscation Level."),
  cl::ZeroOrMore);


static cl::opt<bool>
EnableIndirectCall("irobf-icall", cl::init(false), cl::NotHidden,
                   cl::desc("Enable IR Indirect Call Obfuscation."),
                   cl::ZeroOrMore);
static cl::opt<uint32_t>
LevelIndirectCall("level-icall", cl::init(0), cl::NotHidden,
  cl::desc("Set IR Indirect Call Obfuscation Level."),
  cl::ZeroOrMore);


static cl::opt<bool> EnableIndirectGV(
    "irobf-indgv", cl::init(false), cl::NotHidden,
    cl::desc("Enable IR Indirect Global Variable Obfuscation."),
    cl::ZeroOrMore);
static cl::opt<uint32_t> LevelIndirectGV(
  "level-indgv", cl::init(0), cl::NotHidden,
  cl::desc("Set IR Indirect Global Variable Obfuscation Level."),
  cl::ZeroOrMore);


static cl::opt<bool> EnableIRFlattening(
    "irobf-cff", cl::init(false), cl::NotHidden,
    cl::desc("Enable IR Control Flow Flattening Obfuscation."), cl::ZeroOrMore);


static cl::opt<bool>
EnableIRStringEncryption("irobf-cse", cl::init(false), cl::NotHidden,
                         cl::desc("Enable IR Constant String Encryption."),
                         cl::ZeroOrMore);


static cl::opt<bool>
EnableIRConstantIntEncryption("irobf-cie", cl::init(false), cl::NotHidden,
  cl::desc("Enable IR Constant Integer Encryption."),
  cl::ZeroOrMore);
static cl::opt<uint32_t> LevelIRConstantIntEncryption(
  "level-cie", cl::init(0), cl::NotHidden,
  cl::desc("Set IR Constant Integer Encryption Level."),
  cl::ZeroOrMore);


static cl::opt<bool>
EnableIRConstantFPEncryption("irobf-cfe", cl::init(false), cl::NotHidden,
  cl::desc("Enable IR Constant FP Encryption."),
  cl::ZeroOrMore);

static cl::opt<uint32_t> LevelIRConstantFPEncryption(
  "level-cfe", cl::init(0), cl::NotHidden,
  cl::desc("Set IR Constant FP Encryption Level."),
  cl::ZeroOrMore);

namespace llvm {

struct ObfuscationPassManager : public ModulePass {
  static char            ID; // Pass identification
  SmallVector<Pass *, 8> Passes;

  ObfuscationPassManager() : ModulePass(ID) {
    initializeObfuscationPassManagerPass(*PassRegistry::getPassRegistry());
  };

  StringRef getPassName() const override {
    return "Obfuscation Pass Manager";
  }

  bool doFinalization(Module &M) override {
    bool Change = false;
    for (Pass *P : Passes) {
      Change |= P->doFinalization(M);
      delete (P);
    }
    return Change;
  }

  void add(Pass *P) {
    Passes.push_back(P);
  }

  bool run(Module &M) {
    bool Change = false;
    for (Pass *P : Passes) {
      switch (P->getPassKind()) {
      case PassKind::PT_Function:
        Change |= runFunctionPass(M, (FunctionPass *)P);
        break;
      case PassKind::PT_Module:
        Change |= runModulePass(M, (ModulePass *)P);
        break;
      default:
        continue;
      }
    }
    return Change;
  }

  bool runFunctionPass(Module &M, FunctionPass *P) {
    bool Changed = false;
    for (Function &F : M) {
      Changed |= P->runOnFunction(F);
    }
    return Changed;
  }

  bool runModulePass(Module &M, ModulePass *P) {
    return P->runOnModule(M);
  }

  static ObfuscationOptions *getOptions() {
    ObfuscationOptions *Options = new ObfuscationOptions{
        new ObfOpt{EnableIndirectBr, LevelIndirectBr, "indbr"},
        new ObfOpt{EnableIndirectCall, LevelIndirectCall, "icall"},
        new ObfOpt{EnableIndirectGV, LevelIndirectGV, "indgv"},
        new ObfOpt{EnableIRFlattening, 0, "fla"},
        new ObfOpt{EnableIRStringEncryption, 0, "cse"},
        new ObfOpt{EnableIRConstantIntEncryption, LevelIRConstantIntEncryption, "cie"},
        new ObfOpt{EnableIRConstantFPEncryption, LevelIRConstantFPEncryption, "cfe"}};
    return Options;
  }

  bool runOnModule(Module &M) override {

    if (EnableIndirectBr || EnableIndirectCall || EnableIndirectGV ||
        EnableIRFlattening || EnableIRStringEncryption ||
      EnableIRConstantIntEncryption || EnableIRConstantFPEncryption) {
      EnableIRObfuscation = true;
    }

    if (!EnableIRObfuscation) {
      return false;
    }

    std::unique_ptr<ObfuscationOptions> Options(getOptions());
    unsigned pointerSize = M.getDataLayout().getTypeAllocSize(
        PointerType::getUnqual(M.getContext()));

    add(llvm::createConstantIntEncryptionPass(Options.get()));
    add(llvm::createConstantFPEncryptionPass(Options.get()));

    if (EnableIRStringEncryption || Options->cseOpt()->isEnabled()) {
      add(llvm::createStringEncryptionPass(Options.get()));
    }

    add(llvm::createFlatteningPass(pointerSize, Options.get()));
    add(llvm::createIndirectBranchPass(pointerSize, Options.get()));
    add(llvm::createIndirectCallPass(pointerSize, Options.get()));
    add(llvm::createIndirectGlobalVariablePass(pointerSize, Options.get()));

    bool Changed = run(M);

    return Changed;
  }
};
} // namespace llvm

char ObfuscationPassManager::ID = 0;

ModulePass *llvm::createObfuscationPassManager() {
  return new ObfuscationPassManager();
}

INITIALIZE_PASS_BEGIN(ObfuscationPassManager, "irobf", "Enable IR Obfuscation",
                      false, false)
INITIALIZE_PASS_END(ObfuscationPassManager, "irobf", "Enable IR Obfuscation",
                      false, false)