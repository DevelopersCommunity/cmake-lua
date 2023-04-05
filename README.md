# CMake for Lua

This is a CMake-based project to build and package [Lua](https://lua.org/) and
[LuaRocks](https://luarocks.org/). As the [official Lua binaries
repository](https://luabinaries.sourceforge.net/) is not updated very
frequently, and the [compilation
process](https://www.lua.org/manual/5.4/readme.html) for Windows binaries is not
easy for non-C developers, you can use this project to build an updated version
of Lua.

## Prerequisites

- C compiler (Microsoft Visual C++ or Clang)
- CMake
- Ninja
- WiX Toolset

You can install the first three components with the following
[winget](https://learn.microsoft.com/windows/package-manager/winget/) commands:

```powershell
winget install --id LLVM.LLVM
winget install --id Kitware.CMake
winget install --id Ninja-build.Ninja
```
WiX Toolset is available at <https://github.com/wixtoolset/wix3/releases/>.

## Build

Use the following commands to generate the installation package in both ZIP and
MSI formats:

```powershell
cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build --target package
```
You need Internet access to execute the build process to download the Lua source
code and LuaRocks binaries.

For convenience, you can use the `Build-Lua.ps1` script to run these commands.

If successful, the ZIP and MSI files will be available in the `build` directory.
