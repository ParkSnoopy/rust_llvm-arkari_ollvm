<h1 align="center">KomiMoe/Hikari</h1>
<h2 align="center">Formerly Known As: Arkari</h2>

<h3 align="center">Yet another LLVM-based obfuscator based on Goron</h3>

## Introduction
Currently supported features:
 - Inter-procedural obfuscation
 - Indirect jumps with encrypted jump targets (`-mllvm -irobf-indbr`)
 - Indirect function calls with encrypted target function addresses (`-mllvm -irobf-icall`)
 - Indirect global variable references with encrypted variable addresses (`-mllvm -irobf-indgv`)
 - String (C string) encryption (`-mllvm -irobf-cse`)
 - Inter-procedural control flow flattening obfuscation (`-mllvm -irobf-fla`)
 - Integer constant encryption (`-mllvm -irobf-cie`)
 - Floating-point constant encryption (`-mllvm -irobf-cfe`)
 - Microsoft CXXABI RTTI Name Eraser (Experimental feature!) [Requires specifying configuration file path and `randomSeed` field in the configuration file (32 bytes, padded with 0 if shorter, truncated if longer)] (`-mllvm -irobf-rtti`)
 - All features (`-mllvm -irobf-indbr -mllvm -irobf-icall -mllvm -irobf-indgv -mllvm -irobf-cse -mllvm -irobf-fla -mllvm -irobf-cie -mllvm -irobf-cfe -mllvm -irobf-rtti`)
 - Or manage directly via configuration file (`-mllvm -hikari-cfg="Configuration file path|Your config path"`)

Improvements over Goron:
 - As the original author has explicitly stated that they will not update the LLVM version or continue development for the time being (at least for tens of thousands of years), this version was created (https://github.com/amimo/goron/issues/29)
 - Updated LLVM version
 - Output file name during compilation to avoid frustrating OCD users
 - Fixed numerous known bugs
 ```
 - Fixed SEH explosion issues after obfuscation
 - Fixed issue where global variables imported by DLLs were obfuscated, losing the `__impl` prefix
 - Fixed issue where certain scenarios with LLVM2019 (2022) plugins caused duplicate parameter additions, preventing compilation
 - Fixed stack overflow issue with x86 indirect calls
 - ...
 ```

## Compilation

- Windows (using Ninja, Ninja is the best):
```
Install Ninja in your PATH
Run x64(x86) Native Tools Command Prompt for VS 2022(xx)
Run:

mkdir build_ninja
cd build_ninja
cmake -DCMAKE_CXX_FLAGS="/utf-8" -DCMAKE_INSTALL_PREFIX="./install" -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;lld;lldb" -G "Ninja" ../llvm
ninja
ninja install
```

- Windows with CMake for using Clang (using Ninja, with vcpkg for libxml2, libLZMA, zlib):
```
Install Ninja in your PATH
Run x64 Native Tools Command Prompt for VS 2022
Run:

vcpkg install zlib:x64-windows-static
vcpkg install libLZMA:x64-windows-static
vcpkg install libxml2:x64-windows-static

mkdir build_ninja
cd build_ninja

Replace "YOUR_VCPKG_TOOLCHAIN_FILE" with your vcpkg toolchain file (You can query it with the command "vcpkg integrate install"):
cmake -DCMAKE_CXX_FLAGS="/utf-8" -DCMAKE_INSTALL_PREFIX="./install" -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;lld;lldb" -DLLVM_BUILD_TOOLS=ON -DLLVM_ENABLE_LIBXML2=ON -DCMAKE_TOOLCHAIN_FILE=YOUR_VCPKG_TOOLCHAIN_FILE -DVCPKG_TARGET_TRIPLET="x64-windows-static" -G "Ninja" ../llvm

ninja
ninja install
```

## Usage
Enable specific obfuscation features through compilation options, e.g., to enable indirect jump obfuscation:

```
$ path_to_the/build/bin/clang -mllvm -irobf -mllvm --irobf-indbr test.c
```

For projects using Autotools:
```
$ CC=path_to_the/build/bin/clang or CXX=path_to_the/build/bin/clang
$ CFLAGS+="-mllvm -irobf -mllvm --irobf-indbr" or CXXFLAGS+="-mllvm -irobf -mllvm --irobf-indbr" (or any other obfuscation-related flags)
$ ./configure
$ make
```

## Enable/Disable Specific Obfuscation Options for Specific Functions Using **Annotate**:
The priority of annotations **always overrides** command-line parameters.

`+flag` indicates enabling a feature for the current function, `-flag` indicates disabling a feature for the current function.

String encryption is based on the LLVM Module, so the string encryption option must be included in the compilation options; otherwise, it will not be enabled.

Available annotation flags:
- `fla`
- `icall`
- `indbr`
- `indgv`
- `cie`
- `cfe`

```cpp

[[clang::annotate("-fla -icall")]]
int foo(auto a, auto b) {
    return a + b;
}

[[clang::annotate("+indbr +icall")]]
int main(int argc, char** argv) {
    foo(1, 2);
    std::printf("hello clang\n");
    return 0;
}
// Of course, if you don't mind the hassle, you can also use __attribute((__annotate__(("+indbr"))))
```

If you do not wish to enable Passes for the entire program, you can add only `-mllvm -irobf` to the compilation command-line parameters and use **annotate** to control which functions to obfuscate. Enabling only **-irobf** without using **annotate** will not run any obfuscation Passes.

Of course, using only **annotate** without adding any obfuscation command-line parameters will ***not*** enable any Passes.

You **cannot** enable and disable an obfuscation parameter at the same time!
The following scenario will result in an error:

```cpp
[[clang::annotate("-fla +fla")]]
int fool(auto a, auto b){
    return a + b;
}
```

## Control the Intensity of Specific Obfuscation Passes Using One of the Following Methods
If no intensity is specified, the default intensity is 0. The priority of annotations always overrides command-line parameters.

Available Passes:
- `icall` (Intensity range: 0-3)
- `indbr` (Intensity range: 0-3)
- `indgv` (Intensity range: 0-3)
- `cie` (Intensity range: 0-3)
- `cfe` (Intensity range: 0-3)

1. Specify obfuscation intensity for specific functions using **annotate**:

 `^flag=1` indicates setting the intensity level of a feature for the current function (here, 1)
 
```cpp
// ^icall= specifies the intensity of icall
// +icall indicates enabling icall obfuscation for the current function; if you have enabled icall in the command line, you do not need to add +icall

[[clang::annotate("+icall ^icall=3")]]
int main() {
    std::cout << "HelloWorld" << std::endl;
    return 0;
}
```

2. Specify the intensity of specific obfuscation Passes via command-line parameters

E.g., indirect function calls with encrypted target function addresses, intensity set to 3 (`-mllvm -irobf-icall -mllvm -level-icall=3`)

## Manage Obfuscation Parameters via Configuration File
Add to compilation parameters: `-mllvm -hikari-cfg="Configuration file path|Your config path"`

The path can be absolute or relative to the compiler's working directory.

The configuration file format is JSON.

E.g.:
```json
{
  "randomSeed": "zX0^bS5|vP0@xO4+sF3[pX8,fG2^rT9?",
  "indbr": {
    "enable": true,
    "level": 3
  },
  "icall": {
    "enable": true,
    "level": 3
  },
  "indgv": {
    "enable": true,
    "level": 3
  },
  "cie": {
    "enable": true,
    "level": 3
  },
  "cfe": {
    "enable": true,
    "level": 3
  },
  "fla": {
    "enable": true
  },
  "cse": {
    "enable": true
  },
  "rtti": {
    "enable": true
  }
}
```
