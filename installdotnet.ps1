$temp_dir = "C:\Temp"
if (-not (Test-Path $temp_dir)) { New-Item -ItemType Directory -Path $temp_dir | Out-Null }
Write-Host "Download dotnet/aspnet runtime installer"
$runtimeVersion = "8.0.19"
Invoke-webrequest -uri https://builds.dotnet.microsoft.com/dotnet/Runtime/$runtimeVersion/dotnet-runtime-$runtimeVersion-win-x64.exe -outfile "$temp_dir\dotnet-runtime-win-x64.exe" -Force
Invoke-webrequest -uri https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/$runtimeVersion/aspnetcore-runtime-$runtimeVersion-win-x64.exe -outfile "$temp_dir\aspnet-runtime-win-x64.exe" -Force
Invoke-webrequest -uri https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop/$runtimeVersion/windowsdesktop-runtime-$runtimeVersion-win-x64.exe -outfile "$temp_dir\windowsdesktop-runtime-win-x64.exe" -Force


Write-Host "Instal dotnet runtime $runtimeVersion"
$dotnet = Start-Process "$temp_dir\dotnet-runtime-win-x64.exe" -Wait -ArgumentList "/install", "/quiet", "/norestart", "/log", "$temp_dir\dotnet.log" -PassThru

if ($dotnet.ExitCode -ne 0) {
    Write-Host "Failed to install dotnet 8 runtime $runtimeVersion"
    exit 1
}
Write-Host "dotnet runtime $runtimeVersion installed successfully"

Write-Host "Instal asp.net runtime $runtimeVersion"
$aspnet = Start-Process "$temp_dir\aspnet-runtime-win-x64.exe" -Wait -ArgumentList "/install", "/quiet", "/norestart", "/log", "$temp_dir\aspnet.log" -PassThru


if ($aspnet.ExitCode -ne 0) {
    Write-Host "Failed to install asp.net runtime $runtimeVersion"
    exit 1
}
Write-Host "asp.net runtime $runtimeVersion installed successfully"

Write-Host "Instal WindowsDesktop runtime $runtimeVersion"
$windowsDesktop = Start-Process "$temp_dir\windowsdesktop-runtime-win-x64" -Wait -ArgumentList "/install", "/quiet", "/norestart", "/log", "$temp_dir\aspnet.log" -PassThru


if ($windowsDesktop.ExitCode -ne 0) {
    Write-Host "Failed to install WindowsDesktop runtime $runtimeVersion"
    exit 1
}
Write-Host "WindowsDesktop runtime $runtimeVersion installed successfully"

Write-Host "List dotnet versions"
dotnet --list-runtimes
