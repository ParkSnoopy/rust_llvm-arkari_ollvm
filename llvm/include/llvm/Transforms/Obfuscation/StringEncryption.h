#ifndef OBFUSCATION_STRING_ENCRYPTION_H
#define OBFUSCATION_STRING_ENCRYPTION_H

#include "llvm/IR/PassManager.h"

namespace llvm {
class ModulePass;
class PassRegistry;
class ObfuscationOptions;

ModulePass *createStringEncryptionPass(ObfuscationOptions *argsOptions);
void        initializeStringEncryptionPass(PassRegistry &Registry);

bool rewriteRustFingerprintStrings(Module &M);

class RustStringRewritePass : public PassInfoMixin<RustStringRewritePass> {
public:
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
    return rewriteRustFingerprintStrings(M) ? PreservedAnalyses::none()
                                           : PreservedAnalyses::all();
  }
};

}

#endif