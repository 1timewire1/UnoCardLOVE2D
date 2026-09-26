<#
.SYNOPSIS
    Packages the game as dist/UnoCard.love, and optionally as a Windows folder.

.DESCRIPTION
    A .love file is a zip archive of the game with main.lua at its root. It
    runs with any LOVE 11.x install:  love UnoCard.love

    With -Exe, also creates dist/UnoCard-win64/ with UnoCard.exe (the game
    fused to love.exe) and the DLLs it needs, copied from a LOVE installation.

.EXAMPLE
    ./build.ps1
    ./build.ps1 -Exe
    ./build.ps1 -Exe -LoveDir "C:\Program Files\LOVE"
#>
param(
    [switch]$Exe,
    [string]$LoveDir = "C:\Program Files\LOVE"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = $PSScriptRoot
$dist = Join-Path $root "dist"
$loveFile = Join-Path $dist "UnoCard.love"

# What goes into the game: main.lua, conf.lua, src/, resource/ (+ the license)
$include = @("main.lua", "conf.lua", "LICENSE", "src", "resource")

New-Item -ItemType Directory -Force $dist | Out-Null
if (Test-Path $loveFile) { Remove-Item $loveFile }

# (Compress-Archive of Windows PowerShell 5.1 writes backslashes into the entry
# names, which LOVE cannot read. Write the entries by hand with forward slashes.)
$zip = [System.IO.Compression.ZipFile]::Open($loveFile, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($item in $include) {
        $path = Join-Path $root $item
        $files = if ((Get-Item $path).PSIsContainer) { Get-ChildItem $path -Recurse -File } else { Get-Item $path }
        foreach ($f in $files) {
            $entry = $f.FullName.Substring($root.Length + 1).Replace("\", "/")
            [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $zip, $f.FullName, $entry, [System.IO.Compression.CompressionLevel]::Optimal)
        }
    }
} finally {
    $zip.Dispose()
}

"{0}  ({1:N1} MB)" -f $loveFile, ((Get-Item $loveFile).Length / 1MB)

if ($Exe) {
    $out = Join-Path $dist "UnoCard-win64"
    if (Test-Path $out) { Remove-Item -Recurse -Force $out }
    New-Item -ItemType Directory $out | Out-Null

    # Fuse: love.exe followed by the .love archive is a stand-alone game exe
    $loveExe = Join-Path $LoveDir "love.exe"
    if (-not (Test-Path $loveExe)) { throw "love.exe not found in '$LoveDir' (use -LoveDir)" }
    $fusedExe = Join-Path $out "UnoCard.exe"
    $dst = [System.IO.File]::Create($fusedExe)
    try {
        foreach ($part in $loveExe, $loveFile) {
            $src = [System.IO.File]::OpenRead($part)
            try { $src.CopyTo($dst) } finally { $src.Dispose() }
        }
    } finally {
        $dst.Dispose()
    }

    foreach ($dll in "love.dll", "lua51.dll", "SDL2.dll", "OpenAL32.dll", "mpg123.dll", "msvcp120.dll", "msvcr120.dll", "license.txt") {
        $p = Join-Path $LoveDir $dll
        if (Test-Path $p) { Copy-Item $p $out }
    }

    Copy-Item (Join-Path $root "LICENSE") (Join-Path $out "UnoCard-LICENSE.txt")
    $fusedExe
}
