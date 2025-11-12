# Rust LLVM + Arkari obfuscation module
Merge rust-lang's [llvm-project](https://github.com/rust-lang/llvm-project) and [My Fork](https://github.com/ParkSnoopy/Arkari) of [KomiMoe/Hikari](https://github.com/KomiMoe/Hikari)  
to produce obfuscated LLVM, which can be used as a rustc backend.  
  
### Release Targets  
- Windows 64-bit  
- Linux 64-bit  
- Linux 32-bit (i686)  

> Windows 32-bit is not built because 32-bit system  
> does not provide `Visual Studio Installer` to install build tools  

<br>  
<br>  

# 🕹️ HOW TO USE

## About `RUSTFLAGS`  
- `--irobf` : Turn obfuscation module on  
- `--irobf-indbr` : Indirect jumps with encrypted jump targets  
- `--irobf-icall` : Indirect function calls with encrypted target function addresses  
- `--irobf-indgv` : Indirect global variable references with encrypted variable addresses  
- `--irobf-cse` : C-string encryption  
- `--irobf-cff` : Control-flow flattening (procedure-related)  
- `--irobf-cie` : Integer constant encryption  
- `--irobf-cfe` : Floating-point constant encryption  

### Linux:  
1. Link the toolchain  
```bash
rustup toolchain link <toolchain name> </path/to/extracted/folder_name>
```
2. Run with obfuscation `RUSTFLAGS`  
```bash
RUSTFLAGS="-Cllvm-args=--irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]" \
cargo +<toolchain name> build --release
```

### Windows:  
1. Link the toolchain  
```cmd
rustup toolchain link <toolchain name> <C:\path\to\extracted\folder_name>
```

2. Run with obfuscation `RUSTFLAGS`  
```cmd
set RUSTFLAGS=-Cllvm-args=--irobf -Cllvm-args=--irobf-indbr -Cllvm-args=--irobf-icall -Cllvm-args=--irobf-indgv ...[and more options you want]
cargo +<toolchain name> build --release
set RUSTFLAGS=
```

## 🚧 Issue  

### 💥 Incompatibility  
Maybe some obfuscation flag can cause incompatibility with the crate used in the project. <br>
- Using the `--irobf-cie` flag with the `nu-plugin-engine` crate compile failed. (out of memory)  
- Using the `--irobf-cff` flag with the `windows-rs` crate compile failed.  
- Using the `--irobf-cff` flag with the `rand` crate compile failed. (exit code: 0xc0000005, STATUS_ACCESS_VIOLATION)  
- Using the `--irobf-cff` flag with the `clap` crate compile failed. (exit code: 0xc0000005, STATUS_ACCESS_VIOLATION) (seems like `anstream` `clap_lex` `proc-macro2` `windows-sys` ...and more is not compatible)  

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
- [repo `rust-lang/llvm-project`](https://github.com/rust-lang/llvm-project/commit/480a90482e5b73479c7976d43dc871397ff9d67d) one commit before `21.1.4` version bump
- [repo `ParkSnoopy/Arkari`](https://github.com/ParkSnoopy/Arkari/commit/0fe3a072209320cf9912bd0e861d18ae9931a7e4)

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
extended = false
submodules = true

[target.target-triple]
llvm-config   = "/path/to/-DLLVM_INSTALL_PREFIX/bin/llvm-config"
```

<br>  
<br>  
<br>  

## 💀💀💀 How this project was built...

> Check for [`rust-ollvm-20.1.8`'s README](https://github.com/ParkSnoopy/rust_llvm-arkari_ollvm/blob/rust-ollvm-20.1.8/README.md#-how-this-project-was-built) for detailed informations.
