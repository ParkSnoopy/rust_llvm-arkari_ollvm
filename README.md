# Rust LLVM + Arkari obfuscation module
Merge rust-lang's [llvm-project](https://github.com/rust-lang/llvm-project) and KomiMoe's [Arkari fork](https://github.com/ParkSnoopy/Arkari)  
to produce obfuscated LLVM, which can be used as a rustc backend.  
  
### Release Targets  
- Windows 64-bit  
- Linux 64-bit  
- Linux 32-bit (i386)  

> Windows 32-bit is not built because 32-bit system  
> does not provide `Visual Studio Installer` to install build tools  

<br>  
<br>  

# 🕹️ HOW TO USE

## About `RUSTFLAGS`  
- `-irobf` : Turn obfuscation module on  
- `-irobf-indbr` : Indirect jumps with encrypted jump targets  
- `-irobf-icall` : Indirect function calls with encrypted target function addresses  
- `-irobf-indgv` : Indirect global variable references with encrypted variable addresses  
- `-irobf-cse` : C-string encryption  
- `-irobf-cff` : Control-flow flattening (procedure-related)  
- `-irobf-cie` : Integer constant encryption  
- `-irobf-cfe` : Floating-point constant encryption  

### Linux:  
1. Link the toolchain  
```bash
rustup toolchain link <toolchain name> </path/to/extracted/folder_name>
```
2. Run with obfuscation `RUSTFLAGS`  
```bash
RUSTFLAGS="-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]" \
cargo +<toolchain name> build --release
```

### Windows:  
1. Link the toolchain  
```cmd
rustup toolchain link <toolchain name> <C:\path\to\extracted\folder_name>
```

2. Run with obfuscation `RUSTFLAGS`  
```cmd
set RUSTFLAGS=-Cllvm-args=-irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]
cargo +<toolchain name> build --release
set RUSTFLAGS=
```

## 🚧 Issue  

### 💥 Incompatibility  
Maybe some obfuscation flag can cause incompatibility with the crate used in the project. <br>
- Using the `-mllvm --irobf-cie` flag with the `nu-plugin-engine` crate compile failed. (out of memory)  
- Using the `-mllvm --irobf-cff` flag with the `windows-rs` crate compile failed.  
- Using the `-mllvm --irobf-cff` flag with the `rand` crate compile failed. (exit code: 0xc0000005, STATUS_ACCESS_VIOLATION)  
- Using the `-mllvm --irobf-cff` flag with the `clap` crate compile failed. (exit code: 0xc0000005, STATUS_ACCESS_VIOLATION) (seems like `anstream` `clap_lex` `proc-macro2` `windows-sys` ...and more is not compatible)  

<br>  
<br>  

---
# 🛠️ How to Build

- On Linux (with ninja)
```bash
cmake -GNinja ../llvm -DCMAKE_INSTALL_PREFIX="./Release" -DLLVM_ENABLE_PROJECTS="clang;lld;" -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_INSTALL_UTILS=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_BACKTRACES=OFF -DLLVM_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release
```

- On Windows (with MSBuild)
```bash
cmake ../llvm -DCMAKE_INSTALL_PREFIX="./Release" -DLLVM_ENABLE_PROJECTS="clang;lld;" -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_INSTALL_UTILS=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_BUILD_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_BACKTRACES=OFF -DLLVM_BUILD_DOCS=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded
```

## Used Version
- [repo `rust-lang/llvm-project`, branch `rustc/20.1-2025-07-13`](https://github.com/rust-lang/llvm-project/tree/e8a2ffcf322f45b8dce82c65ab27a3e2430a6b51)
- [repo `ParkSnoopy/Arkari`, branch `llvm-20.x`](https://github.com/ParkSnoopy/Arkari/tree/98a7c741c9427da16c2c0f3991b60ce60e94143a)

## Used Config
`config.toml` for building `rust-lang/rust`

> Replace `"target-triple"` by wanted target triple  
> (e.g. "x86_64-unknown-linux-gnu" or "x86_64-pc-windows-msvc" etc.)  

```toml
change-id = 999999

[llvm]
targets          = "X86"
download-ci-llvm = false
link-shared      = false
ninja            = true

[build]
build  =  "target-triple"
host   = ["target-triple"]
target = ["target-triple"]
extended = true
submodules = true

[target."target-triple"]
llvm-config   = "/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config"
```

## 💀💀💀 How this project was built...

1. Clone all resources: 
```bash
git clone --depth 1 --single-branch --branch 1.88.0 https://github.com/rust-lang/rust rust-src
git clone --depth 1 --single-branch --branch rustc/20.1-2025-07-13 --recursive https://github.com/rust-lang/llvm-project rust-llvm
git clone --depth 1 --single-branch --branch llvm-20.x --recursive https://github.com/ParkSnoopy/Arkari arkari-ollvm
```

2. Check for diff and modify patch file (preferably manual)
```bash
cd rust-llvm
git diff --no-prefix ./llvm ../arkari-ollvm/llvm > ../diff-llvm.patch
git diff --no-prefix ./clang ../arkari-ollvm/clang > ../diff-clang.patch
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
