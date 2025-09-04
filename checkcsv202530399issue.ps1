Write-Host "===== Checking Installed Components ====="

# 1. Check Visual Studio
$vsPath = "HKLM:\SOFTWARE\Microsoft\VisualStudio\Setup\Instances"
if (Test-Path $vsPath) {
    Get-ChildItem $vsPath | ForEach-Object {
        $props = Get-ItemProperty $_.PsPath
        Write-Host "Visual Studio Instance:" $props.DisplayName "Version:" $props.InstallationVersion
    }
} else {
    Write-Host "Visual Studio: Not Installed"
}

# 2. Check PowerShell 7+
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    $pwshVer = & pwsh -NoProfile -Command { $PSVersionTable.PSVersion }
    Write-Host "PowerShell 7+ Installed, Version:" $pwshVer
} else {
    Write-Host "PowerShell 7+: Not Installed"
}

# 3. Check .NET runtimes
if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    Write-Host "Dotnet Runtimes:"
    & dotnet --list-runtimes
} else {
    Write-Host ".NET Runtime: Not Installed"
}
