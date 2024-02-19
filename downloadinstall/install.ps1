param (
    [string]$packages
)

$baseInstallerUrl = "https://ctcdownloads.blob.core.windows.net/uinstall/installerzips/"
$tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "UniversalInstaller")

$packageArray = $packages -split ","

:: DEBUG
$packageArray = @("notepadplusplus-LATEST")

foreach ($package in $packageArray) {
    $zipPath = Join-Path $tempDir.FullName "$package.zip"
    $url = $baseInstallerUrl + $package + "_installer.zip"
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $tempDir.FullName
}

# BEGIN: 4f5d6g7h8j9k
foreach ($dir in Get-ChildItem -Path $tempDir.FullName -Directory) {
    $batchFile = Join-Path $dir.FullName "doinstall.cmd"
    if (Test-Path $batchFile) {
        Start-Process -FilePath $batchFile -WorkingDirectory $dir.FullName -Wait
    }
}
# END: 4f5d6g7h8j9k
    

