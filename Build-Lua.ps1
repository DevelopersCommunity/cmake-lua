$ErrorActionPreference = 'Stop'

if (Test-Path -Path build -PathType Container)
{
    Remove-Item -Recurse -Force -Path build
}
cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build --target package
