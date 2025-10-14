# rust_llvm-arkari_ollvm

## Used Version
- repo `rust-lang/llvm-project`, branch `rustc/19.1-2024-12-03`, commit [`ab51eccf88f5321e7c60591c5546b254b6afab99`](https://github.com/rust-lang/llvm-project/commit/ab51eccf88f5321e7c60591c5546b254b6afab99)
- repo `KomiMoe/Arkari`, branch `llvm-19.x`, commit [`d3d013d088b23d901d3af7a84cc730d6c940b5d3`](https://github.com/KomiMoe/Arkari/commit/d3d013d088b23d901d3af7a84cc730d6c940b5d3)

## Used Config
`config.toml` for building `rust-lang/rust`

```toml
change-id = 999999

[llvm]
download-ci-llvm = false
optimize = true
ninja = true
targets = "X86"
use-linker = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/lld.exe"

[rust]
debug = false
channel = "nightly"

[build]
target = ["x86_64-pc-windows-gnu"]
extended = false

[target.x86_64-pc-windows-gnu]
llvm-config = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/llvm-config.exe"
llvm-filecheck = "C:/path/to/-DCMAKE_INSTALL_PREFIX/bin/FileCheck.exe"
```
