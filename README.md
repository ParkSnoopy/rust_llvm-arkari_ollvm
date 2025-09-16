# rust LLVM + Arkari obfuscation module
merge rust-lang's [llvm-project](https://github.com/rust-lang/llvm-project) and KomiMoe's [Arkari fork](https://github.com/ParkSnoopy/Arkari) to produce obfuscated llvm, which can be used as a rustc backend

# 🕹️ HOW TO USE
### Linux:
```bash
rustup toolchain link <toolchain name> </path/to/extracted/stage1>
RUSTFLAGS="-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]" cargo +<toolchain name> build --release
```
### Windows:
At first, link the toolchain.
```cmd
rustup toolchain link <toolchain name> <C:\path\to\extracted\stage1>
```

And use by set `RUSTFLAGS` and run `cargo` with linked toolchain: 
```cmd
set RUSTFLAGS=-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]
cargo +<toolchain name> build --release
```

Better to save the script like below as `.bat` script and name like `obfs-cargo`  
Obfuscation module v1.7.0 supports JSON config. Check the [original repo](https://github.com/komimoe/arkari?tab=readme-ov-file#%E4%BB%8B%E7%BB%8D) for more info. 
```bat
@echo off
shift
set RUSTFLAGS=-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]
cargo %*
set RUSTFLAGS=
```
And then use, like, 
```cmd
obfs-cargo +<toolchain name> build --release
```


## 🚧 Issue

### 💥 Incompatibility
Maybe some obfuscation flag can cause incompatibility with the crate used in the project. <br>
- Using the `-mllvm --irobf-cff` flag with the `windows-rs` crate compile failed. 
- Using the `-mllvm --irobf-cie` flag with the `nu-plugin-engine` crate compile failed. (out of memory)
- Using the `-mllvm --irobf-cff` flag with the `rand` crate compile failed. (exit code: 0xc0000005, STATUS_ACCESS_VIOLATION)
- Using the `-mllvm --irobf-cff` flag with the `clap` crate compile failed. (exit code: 0xc0000005, STATUS_ACCESS_VIOLATION) (seems like `anstream` `clap_lex` `proc-macro2` `windows-sys` ...and more is not compatible)

<br>  
<br>  

---
# 🛠️ How to Build

- On Linux: 
```bash
cmake -GNinja ../llvm -DCMAKE_INSTALL_PREFIX="./Release" -DLLVM_ENABLE_PROJECTS="clang;lld;" -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_INSTALL_UTILS=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_BACKTRACES=OFF -DLLVM_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release
```

- On Windows: 
```bash
cmake ../llvm -DCMAKE_INSTALL_PREFIX="./Release" -DLLVM_ENABLE_PROJECTS="clang;lld;" -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_INSTALL_UTILS=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_BACKTRACES=OFF -DLLVM_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
```

## Used Version
- repo `rust-lang/llvm-project`, branch `rustc/20.1-2025-02-13`, commit [`99f0e05`](https://github.com/rust-lang/llvm-project/commit/99f0e0531688a822a753cc585b7408b069cb6822)
- repo `KomiMoe/Arkari`, branch `llvm-20.x`, commit [`f0ae579`](https://github.com/KomiMoe/Arkari/commit/f0ae579eb730140b109a7a861002e1d7064edbd0)

## Used Config
`config.toml` for building `rust-lang/rust`

> Alter `x86_64-unknown-linux-gnu`s under `[build]` to desired target triple

```toml
change-id = 999999

[llvm]
targets          = "X86"
download-ci-llvm = false
link-shared      = false
ninja            = true

[build]
build  =  "x86_64-unknown-linux-gnu"
host   = ["x86_64-unknown-linux-gnu"]
target = ["x86_64-unknown-linux-gnu"]
extended = true
submodules = false

[target.i686-unknown-linux-gnu]
llvm-config   = "/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config"

[target.x86_64-unknown-linux-gnu]
llvm-config   = "/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config"

[target.x86_64-pc-windows-msvc]
llvm-config   = "/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config"

```

## 💀💀💀 How this project was built...

Clone all resources: 
> Do not use `--depth 1` when `rust-lang/llvm-project`'s LLVM version  
> and `KomiMoe/Arkari`'s LLVM version not match.  
> You may have to `git reset --hard <commit-hash>` to desired LLVM version  

```bash
git clone --depth 1 --single-branch --branch 1.88.0 https://github.com/rust-lang/rust rust-1.88.0
git clone --depth 1 --single-branch --branch rustc/20.1-2025-02-13 --recursive https://github.com/rust-lang/llvm-project rust-llvm-20
git clone --depth 1 --single-branch --branch llvm-20.x --recursive https://github.com/KomiMoe/Arkari arkari-ollvm-20
```

Copy-paste **WITHOUT OVERWRITE** from `arkari-ollvm-20/llvm` to `rust-llvm-20/llvm`

```bash
cp -r --no-clobber arkari-ollvm-20/llvm rust-llvm-20/llvm
```

Check for diff and modify patch file

```bash
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

```bash
patch -p0 < ../diff-clang.patch
patch -p0 < ../diff-llvm.patch
cd ..
```

Afterward is identical with [this article (archived)](https://web.archive.org/web/20250302083137/https://vrls.ws/posts/2023/06/obfuscating-rust-binaries-using-llvm-obfuscator-ollvm/)'s **Bootstrapping Rust Compiler** Section. 

# ⚰️
