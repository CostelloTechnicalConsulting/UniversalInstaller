$installersDir = "D:\GitHub\UniversalInstaller\UniversalInstaller\installers"
$installerZipsDir = "D:\GitHub\UniversalInstaller\UniversalInstaller\installer-zips"

# Get all subdirectories in the installers directory
$subDirs = Get-ChildItem -Path $installersDir -Directory

# Loop through each subdirectory and create a zip archive
foreach ($subDir in $subDirs) {
    $zipFileName = "$($subDir.Name).zip"
    $zipFilePath = Join-Path -Path $installerZipsDir -ChildPath $zipFileName
    Compress-Archive -Path $subDir.FullName -DestinationPath $zipFilePath -Force
}
