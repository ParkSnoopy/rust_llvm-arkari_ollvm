#ifndef OBFUSCATION_DUMMYCODE_H
#define OBFUSCATION_DUMMYCODE_H

// Namespace
namespace llvm {
class FunctionPass;
class PassRegistry;
class ObfuscationOptions;

FunctionPass *createDummyCodePass(ObfuscationOptions *argsOptions);
void         initializeDummyCodePass(PassRegistry &Registry);

}

#endif
