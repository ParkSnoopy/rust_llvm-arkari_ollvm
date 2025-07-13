# rust LLVM + Arkari obfuscation module
merge rust-lang's [llvm-project](https://github.com/rust-lang/llvm-project) and KomiMoe's [Arkari fork](https://github.com/ParkSnoopy/Arkari) to produce obfuscated llvm, which can be used as rustc backend

# HOW TO USE
### Linux:
```
rustup toolchain link <toolchain name> </path/to/extracted/stage1>
RUSTFLAGS="-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]" cargo +<toolchain name> build --release
```
### Windows:
At first, link toolchain
```cmd
rustup toolchain link <toolchain name> <C:\path\to\extracted\stage1>
```

And use like: 
```cmd
set RUSTFLAGS=-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]
cargo +<toolchain name> build --release
```

Better to save the script like below as `.bat` script and name like `obfs-cargo`  
Obfuscation module v1.7.0 supports JSON config. Check the [original repo](https://github.com/komimoe/arkari?tab=readme-ov-file#%E9%80%9A%E8%BF%87%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E7%AE%A1%E7%90%86%E6%B7%B7%E6%B7%86%E5%8F%82%E6%95%B0) for more info. 
```bat
@echo off
shift
set RUSTFLAGS_BAK=%RUSTFLAGS%
set RUSTFLAGS=-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]
cargo %*
set RUSTFLAGS=%RUSTFLAGS_BAK%
set RUSTFLAGS_BAK=
```
and then use like: 
```cmd
obfs-cargo +<toolchain name> build --release
```


## Issue
Maybe some obfuscation flag can cause incompatibility with the crate used in the project. <br>
- Using the `-mllvm --irobf-cff` flag with the `windows-rs` crate compile failed. 
- Using the `-mllvm --irobf-cie` flag with the `nu-plugin-engine` crate compile failed. (out of memory)

## How to Build
- I used `-DCMAKE_INSTALL_PREFIX="./Release"` because it seemed like `rust-lang/rust`'s [`x.py`](https://github.com/rust-lang/rust/blob/1.86.0/x.py) assumed it
```
cmake /path/to/llvm-project/llvm -DCMAKE_INSTALL_PREFIX="./Release" -DLLVM_ENABLE_PROJECTS="clang;lld;" -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_INSTALL_UTILS=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_BACKTRACES=OFF -DLLVM_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
cmake --build .
cmake --build . --target install
```

## Used Version
- repo `rust-lang/llvm-project`, branch `rustc/20.1-2025-02-13`, commit [`99f0e05`](https://github.com/rust-lang/llvm-project/commit/99f0e0531688a822a753cc585b7408b069cb6822)
- repo `KomiMoe/Arkari`, branch `llvm-20.x`, commit [`f0ae579`](https://github.com/KomiMoe/Arkari/commit/f0ae579eb730140b109a7a861002e1d7064edbd0)

## Used Config
`config.toml` for building `rust-lang/rust`

```toml
change-id = 999999

[llvm]
download-ci-llvm = false
optimize = true
ninja = true
targets = "X86"
use-linker = "/path/to/-DCMAKE_INSTALL_PREFIX/bin/lld"
# maybe gcc doesn't accept absolute path lld
clang = true

[rust]
debug = false
channel = "nightly"

[build]
target = ["x86_64-pc-windows-msvc"]
extended = false

[target.x86_64-pc-windows-gnu]
llvm-config = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config.exe"
llvm-filecheck = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/FileCheck.exe"

[target.x86_64-pc-windows-msvc]
llvm-config = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config.exe"
llvm-filecheck = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/FileCheck.exe"

[target.x86_64-unknown-linux-gnu]
llvm-config = "/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config"
llvm-filecheck = "/path/to/-DCMAKE_INSTALL_PREFIX/bin/FileCheck"
```

## How this was built

Clone all resources: 
> Do not use `--depth 1` when `rust-lang/llvm-project`'s LLVM version and `KomiMoe/Arkari`'s LLVM version not match
> You may have to `git reset --hard <commit-hash>` to desired LLVM version

```sh
git clone --depth 1 --single-branch --branch 1.88.0 https://github.com/rust-lang/rust rust-1.88.0
git clone --depth 1 --single-branch --branch rustc/20.1-2025-02-13 --recursive https://github.com/rust-lang/llvm-project rust-llvm-20
git clone --depth 1 --single-branch --branch llvm-20.x --recursive https://github.com/KomiMoe/Arkari arkari-ollvm-20
```

Copy-Paste **WITHOUT OVERWRITE** from `arkari-ollvm-20/llvm` to `rust-llvm-20/llvm`

```sh
cp -r --no-clobber arkari-ollvm-20/llvm rust-llvm-20/llvm
```

Check for diff and modify patch file

```sh
cd rust-llvm-20
git diff --no-prefix ./llvm ../arkari-ollvm-20/llvm > ../diff-llvm.patch
git diff --no-prefix ./clang ../arkari-ollvm-20/clang > ../diff-clang.patch
```

Remove all diffs except **all** **`CMakeLists.txt`** **and these:**

```txt
llvm/include/llvm/LinkAllPasses.h
llvm/lib/Passes/PassBuilderPipelines.cpp
```

Apply

```sh
patch -p0 < ../diff-clang.patch
patch -p0 < ../diff-llvm.patch
cd ..
```

Afterward is identical with [This article](https://vrls.ws/posts/2023/06/obfuscating-rust-binaries-using-llvm-obfuscator-ollvm/)'s **Bootstrapping Rust Compiler** Section. 
