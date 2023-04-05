$ErrorActionPreference = 'Stop'

if (Test-Path -Path install -PathType Container)
{
    Remove-Item -Recurse -Force -Path install
}
cmake --install build --prefix install
