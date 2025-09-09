$dotnetPath = "C:\Program Files\dotnet"

# SDK folder
$sdkPath = Join-Path $dotnetPath "sdk\8.0.14"
if (Test-Path $sdkPath) {
    Write-Output "Removing SDK $sdkPath"
    Remove-Item -Recurse -Force $sdkPath
}

# Runtime: Microsoft.NETCore.App
$coreRuntime = Join-Path $dotnetPath "shared\Microsoft.NETCore.App\8.0.14"
if (Test-Path $coreRuntime) {
    Write-Output "Removing runtime $coreRuntime"
    Remove-Item -Recurse -Force $coreRuntime
}

# Runtime: Microsoft.AspNetCore.App
$aspnetRuntime = Join-Path $dotnetPath "shared\Microsoft.AspNetCore.App\8.0.14"
if (Test-Path $aspnetRuntime) {
    Write-Output "Removing runtime $aspnetRuntime"
    Remove-Item -Recurse -Force $aspnetRuntime
}

Write-Output "Uninstallation of .NET 8.0.14 completed."


$windowsRuntime = Join-Path $dotnetPath "shared\Microsoft.WindowsDesktop.App\8.0.14"
if (Test-Path $windowsRuntime) {
    Write-Output "Removing runtime $windowsRuntime"
    Remove-Item -Recurse -Force $windowsRuntime
}

# Run PowerShell as Administrator

$versions = @("x86", "x64")
$dotnetRegPath = "HKLM:\SOFTWARE\dotnet\Setup\InstalledVersions"

foreach ($arch in $versions) {
    $installPath = Join-Path $dotnetRegPath $arch

    if (Test-Path $installPath) {
        $props = Get-ItemProperty -Path $installPath

        foreach ($name in $props.PSObject.Properties.Name) {
            $value = (Get-ItemProperty -Path $installPath).$name
            if ($value -like "*8.0.14*") {
                Write-Output "Removing registry value '$name' with path '$value' from $installPath"
                Remove-ItemProperty -Path $installPath -Name $name -Force
            }
        }
    }
}

Write-Host "List dotnet versions"
dotnet --info
