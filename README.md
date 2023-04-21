# CMake for Lua

This is a CMake-based project to build and package [Lua](https://lua.org/) and
[LuaRocks](https://luarocks.org/). As the [official Lua binaries
repository](https://luabinaries.sourceforge.net/) is not updated very
frequently, and the [compilation
process](https://www.lua.org/manual/5.4/readme.html) for Windows binaries is not
straightforward for non-C developers, you can use this project to build an
updated version of Lua.

The installer is used by the `DEVCOM.Lua`
[winget](https://learn.microsoft.com/windows/package-manager/) package. You can
install it with the following command:

```powershell
winget install --id DEVCOM.Lua
```

## Build prerequisites

- C compiler ([Microsoft Visual
  C++](https://learn.microsoft.com/cpp/overview/visual-cpp-in-visual-studio) or
  [Clang](https://clang.llvm.org/))
- [CMake](https://cmake.org/)
- [Ninja](https://ninja-build.org/)
- [WiX v3](https://wixtoolset.org/docs/wix3/) (if packaging on Windows)

You can install the first three components with the following
[winget](https://learn.microsoft.com/windows/package-manager/winget/) commands:

```powershell
winget install --id LLVM.LLVM
winget install --id Kitware.CMake
winget install --id Ninja-build.Ninja
```

WiX v3 is available at <https://github.com/wixtoolset/wix3/releases/>. It
requires .NET Framework 3.5 that can be installed with the following command:

```powershell
Start-Process `
    -FilePath pwsh `
    -ArgumentList "-Command `"& {Enable-WindowsOptionalFeature -Online -FeatureName NetFx3}`"" `
    -Wait `
    -Verb RunAs
```

Update your path environment with `setx` (supposing you installed the tools in
their default directories):

```powershell
setx PATH ($(Get-ItemProperty -Path HKCU:\Environment -Name Path).Path + "$env:ProgramFiles\LLVM\bin;${env:ProgramFiles(x86)}\WiX Toolset v3.11\bin")
```

Check if `PATH` was set correctly:

```
Get-Command clang
Get-Command cmake
Get-Command ninja
Get-Command candle
```

You may need to restart your Windows session if you can't find `ninja` even
after restarting your terminal.

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
