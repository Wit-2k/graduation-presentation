@echo off
setlocal

cd /d "%~dp0"

if "%PORT%"=="" set "PORT=8787"

if not exist "%~dp0caddy\caddy.exe" (
  echo caddy\caddy.exe was not found.
  echo Rebuild the offline package with npm run build:offline.
  pause
  exit /b 1
)

start "" "http://127.0.0.1:%PORT%/1"
"%~dp0caddy\caddy.exe" run --config "%~dp0Caddyfile" --adapter caddyfile

endlocal
