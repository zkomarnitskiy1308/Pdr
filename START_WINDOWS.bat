@echo off
setlocal EnableExtensions DisableDelayedExpansion
pushd "%~dp0"
if errorlevel 1 goto directory_error
where py >nul 2>&1
if errorlevel 1 goto python_fallback
py -3 --version >nul 2>&1
if errorlevel 1 goto python_fallback
py -3 "start_server.py"
goto finished
:python_fallback
python --version >nul 2>&1
if errorlevel 1 goto python_missing
python "start_server.py"
goto finished
:python_missing
echo ERROR: Python 3 was not found.
echo Install Python 3 from https://www.python.org/downloads/windows/
set "exit_code=1"
goto end
:directory_error
echo ERROR: Cannot open the application directory.
pause
exit /b 1
:finished
set "exit_code=%errorlevel%"
if not "%exit_code%"=="0" echo ERROR: The local web server failed to start.
:end
popd
if not "%exit_code%"=="0" pause
exit /b %exit_code%
