# Enable CVE-2013-3900 mitigation (EnableCertPaddingCheck) for both 32-bit and 64-bit systems

function Set-EnableCertPaddingCheck($path) {
    # Ensure the registry key exists
    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
        Write-Host "Created registry path: $path"
    } else {
        Write-Host "Registry path exists: $path"
    }

    # Set or update the registry value
    New-ItemProperty -Path $path -Name "EnableCertPaddingCheck" -PropertyType DWord -Value 1 -Force | Out-Null
    Write-Host "EnableCertPaddingCheck set to 1 at $path"
}

# Always set for 32-bit path
Set-EnableCertPaddingCheck "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config"

# If system is 64-bit, also set the Wow6432Node path
if ([Environment]::Is64BitOperatingSystem) {
    Set-EnableCertPaddingCheck "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config"
}

Write-Host "`nPlease restart your system to apply the changes."
