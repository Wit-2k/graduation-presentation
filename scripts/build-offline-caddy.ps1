param(
  [string]$OutDir = "offline-caddy",
  [int]$Port = 8787,
  [string]$CaddyUrl = "https://caddyserver.com/api/download?os=windows&arch=amd64",
  [string]$CaddyExePath = ""
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$OutRoot = [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $OutDir))
$RepoRootPath = [System.IO.Path]::GetFullPath($RepoRoot)

if (-not $OutRoot.StartsWith($RepoRootPath + [System.IO.Path]::DirectorySeparatorChar)) {
  throw "Output directory must stay inside the repository: $OutRoot"
}

Set-Location -LiteralPath $RepoRoot

npm run build

if (Test-Path -LiteralPath $OutRoot) {
  # The package is fully generated, so replacing it avoids stale hashed assets.
  Remove-Item -LiteralPath $OutRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $OutRoot | Out-Null
New-Item -ItemType Directory -Path (Join-Path $OutRoot "caddy") | Out-Null

Copy-Item -LiteralPath (Join-Path $RepoRoot "dist") -Destination (Join-Path $OutRoot "site") -Recurse
Copy-Item -LiteralPath (Join-Path $RepoRoot "packaging\caddy\Caddyfile") -Destination (Join-Path $OutRoot "Caddyfile")
Copy-Item -LiteralPath (Join-Path $RepoRoot "packaging\caddy\start.bat") -Destination (Join-Path $OutRoot "start.bat")

$CaddyExe = Join-Path $OutRoot "caddy\caddy.exe"
if ($CaddyExePath) {
  $ResolvedCaddyExe = (Resolve-Path -LiteralPath $CaddyExePath).Path
  Copy-Item -LiteralPath $ResolvedCaddyExe -Destination $CaddyExe
} else {
  Invoke-WebRequest -Uri $CaddyUrl -OutFile $CaddyExe
}

$Readme = @"
Offline Slidev package
======================

How to run:
1. Double-click start.bat.
2. The browser opens http://127.0.0.1:$Port/1.
3. Keep the terminal window open while presenting.
4. Press Ctrl+C in the terminal to stop the local server.

Notes:
- The target computer does not need Node.js, npm, or Slidev.
- The presentation is served only on 127.0.0.1.
- To change the port, run: set PORT=8788 && start.bat
"@

Set-Content -LiteralPath (Join-Path $OutRoot "README.txt") -Value $Readme -Encoding ascii

$ZipPath = Join-Path $RepoRoot "$OutDir.zip"
if (Test-Path -LiteralPath $ZipPath) {
  Remove-Item -LiteralPath $ZipPath -Force
}

Compress-Archive -Path (Join-Path $OutRoot "*") -DestinationPath $ZipPath

Write-Host "Offline package created:"
Write-Host "  $OutRoot"
Write-Host "  $ZipPath"
