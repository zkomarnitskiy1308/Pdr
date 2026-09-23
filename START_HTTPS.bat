@echo off
setlocal EnableExtensions DisableDelayedExpansion
pushd "%~dp0"
if errorlevel 1 goto directory_error
where cloudflared >nul 2>&1
if errorlevel 1 goto cloudflared_missing
start "PDR B local web server" /D "%CD%" "%ComSpec%" /k "call START_WINDOWS.bat"
if errorlevel 1 goto start_failed
echo Starting the local web server...
timeout /t 3 /nobreak >nul
echo Starting the HTTPS tunnel...
cloudflared tunnel --url http://127.0.0.1:8080
set "exit_code=%errorlevel%"
if not "%exit_code%"=="0" echo ERROR: HTTPS tunnel failed. Check the server window.
goto done
:cloudflared_missing
echo ERROR: cloudflared.exe was not found in PATH.
echo Install it using the official Cloudflare instructions:
echo https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/
set "exit_code=1"
goto done
:start_failed
echo ERROR: Could not open the local web server window.
set "exit_code=1"
goto done
:directory_error
echo ERROR: Cannot open the application directory.
pause
exit /b 1
:done
popd
pause
exit /b %exit_code%
