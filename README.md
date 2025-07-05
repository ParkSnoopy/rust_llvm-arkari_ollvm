# rust_llvm-arkari_ollvm
merge rust-lang's [llvm-project](https://github.com/rust-lang/llvm-project) and KomiMoe's [Arkari](https://github.com/KomiMoe/Arkari) to produce obfuscated llvm, which can be used as rustc backend

## How to Build

- `-DCMAKE_INSTALL_PREFIX="./Release"` because it seemed like `rust-lang/rust`'s [`x.py`](https://github.com/rust-lang/rust/blob/1.86.0/x.py) assumed it
```bash
cmake ../rust_llvm-arkari_ollvm/llvm -DCMAKE_INSTALL_PREFIX="./Release" -DLLVM_ENABLE_PROJECTS="clang;lld;" -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_INSTALL_UTILS=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_BACKTRACES=OFF -DLLVM_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build .
cmake --build . --target install
```

## Status


## Used Version
`rust-lang` one used just before the commit [`Bump version to 19.1.4`](https://github.com/rust-lang/llvm-project/commit/a3f0f1d004a61ef94c115e7e28863ce0b476aa99) to match `Komimoe`'s latest `19.X` oLLVM
- repo `rust-lang/llvm-project`, branch `rustc/20.1-2025-02-13`, commit [`ab51eccf88f5321e7c60591c5546b254b6afab99`](https://github.com/rust-lang/llvm-project/commit/ab51eccf88f5321e7c60591c5546b254b6afab99)
- repo `KomiMoe/Arkari`, branch `llvm-19.x`, commit [`d3d013d088b23d901d3af7a84cc730d6c940b5d3`](https://github.com/KomiMoe/Arkari/commit/d3d013d088b23d901d3af7a84cc730d6c940b5d3)

## Used Config
`config.toml` for building `rust-lang/rust`

```toml
[llvm]
download-ci-llvm = false
optimize = true
# If using Visual Studio Installer, specifying the build tool as Ninja could cause a linking error.
# Ninja is fast, but what we need here is a stable build environment, not a speedy build failure.
ninja = false
targets = "X86"
experimental-targets = ""

[rust]
debug = false
channel = "dev"
codegen-backends = ["llvm"]

[build]
target = ["x86_64-pc-windows-gnu"]
tools = [
    "cargo",
]

[target.x86_64-pc-windows-gnu]
llvm-config = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config.exe"
llvm-filecheck = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/FileCheck.exe"
```
<br>

## How this was built
> [This article was the most helpful one](https://vrls.ws/posts/2023/06/obfuscating-rust-binaries-using-llvm-obfuscator-ollvm/)
<br>

Clone all resources:
```bash
git clone --single-branch --branch 1.86.0 --depth 1 https://github.com/rust-lang/rust rust-1.86.0
git clone --single-branch --branch rustc/19.1-2024-12-03 --recursive https://github.com/rust-lang/llvm-project rust-llvm-19
git clone --single-branch --branch llvm-19.x --recursive --depth 1 https://github.com/KomiMoe/Arkari arkari-ollvm-19

cd rust-llvm-19
git reset --hard ab51ecc
cat cmake/Modules/LLVMVersion.cmake
cd ..
```
<br>

I used rust `1.86.0`, because this was the latest LLVM19 rust version AFAIK, <br>
and I don't want to make trouble with LLVM version. <br>
`cat` output should be like below:

```cmake
   1   │ # The LLVM Version number information
   2   │
   3   │ if(NOT DEFINED LLVM_VERSION_MAJOR)
   4   │   set(LLVM_VERSION_MAJOR 19)
   5   │ endif()
   6   │ if(NOT DEFINED LLVM_VERSION_MINOR)
   7   │   set(LLVM_VERSION_MINOR 1)
   8   │ endif()
   9   │ if(NOT DEFINED LLVM_VERSION_PATCH)
  10   │   set(LLVM_VERSION_PATCH 3)
  11   │ endif()
  12   │ if(NOT DEFINED LLVM_VERSION_SUFFIX)
  13   │   set(LLVM_VERSION_SUFFIX)
  14   │ endif()
  15   │ 
```
<br>

After all this, simply copy-paste from `arkari-ollvm-19/llvm` to `rust-llvm-19` <br>
and check for leftover diff

```bash
cp -r --no-clobber arkari-ollvm-19/llvm rust-llvm-19/llvm
git diff rust-llvm-19/llvm arkari-ollvm-19/llvm > diff.patch
```

Now check for the `diff.patch` file and update all files one-by-one. <br>
Actually, there is not that much to update. <br>
<br>
And there are some missing updates, so I've struggled with it for a long time...<br>
<br>
That's it! <br>
Afterward job is identical with [This article](https://vrls.ws/posts/2023/06/obfuscating-rust-binaries-using-llvm-obfuscator-ollvm/)'s **Bootstrapping Rust Compiler** Section. <br>
<br>
Just a few hours to wait for facing LLVM build failure, <br>
or another few hours to face `x.py` complete unsuccessfully while compiling `rustc_driver`! <br>
