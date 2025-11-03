$ServiceFabricRuntimeDownloadLink = `
        "https://download.microsoft.com/download/b/8/a/b8a2fb98-0ec1-41e5-be98-9d8b5abf7856/MicrosoftServiceFabric.11.2.274.1.exe"
    $InstallationFolder = "C:\ServiceFabricRuntimeTemp\"

    New-Item -ItemType Directory -Force -Path $InstallationFolder
    Write-Host "Installing Service Fabric Runtime"

    Invoke-WebRequest `
        -Uri $ServiceFabricRuntimeDownloadLink `
        -OutFile ($InstallationFolder + "MicrosoftServiceFabric.exe");

    Write-Host "Setting up Service Fabric runtime"
    $ExecutablePath = Join-Path -Path $InstallationFolder `
        -ChildPath "MicrosoftServiceFabric.exe"
    Start-Process -FilePath $ExecutablePath `
        -ArgumentList "/accepteula /quiet" -Wait -NoNewWindow

    Write-Host "Deleting the executables downloaded"
    Remove-Item -Path $InstallationFolder -Recurse

    if (-not (Test-Path "C:\Program Files\Microsoft Service Fabric\bin\FabricHost.exe")) {
        throw 'Failed to install Service Fabric runtime. Please retry command with admin privileges.'
    }

    Write-Host "Service Fabric runtime installed successfully!"
	
$path = "C:\Program Files\Microsoft Service Fabric\bin\FabricHost.exe"

if (Test-Path $path) {
    (Get-Item $path).VersionInfo | Select-Object ProductVersion, FileVersion
} else {
    Write-Host "Service Fabric not found at $path" -ForegroundColor Red
}
