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

# Get all zip files in the installer-zips directory
$zipFiles = Get-ChildItem -Path $installerZipsDir -File -Filter "*.zip"
# For each unique prefix, up to the first -, find the most recently created zip file and copy it with the pattern <prefix>-LATEST_installer.zip
$zipFiles | Group-Object -Property { $_.Name.Split("-")[0] } | ForEach-Object {
    $latestZipFile = $_.Group | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
    $latestZipFileName = "$($latestZipFile.Name.Split("-")[0])-LATEST_installer.zip"
    $latestZipFilePath = Join-Path -Path $installerZipsDir -ChildPath $latestZipFileName
    Copy-Item -Path $latestZipFile.FullName -Destination $latestZipFilePath -Force
}

# Get all zip files in the installer-zips directory that don't have the pattern <prefix>-LATEST_installer.zip
$zipFiles = Get-ChildItem -Path $installerZipsDir -File -Filter "*.zip" | Where-Object { $_.Name -notmatch '-LATEST_installer.zip$' }

# For each unique prefix, up to the first -, find the file with the highest version number after the - and before the _ copy it with the pattern <prefix>-LATEST_installer.zip
$zipFiles | Group-Object -Property { $_.Name.Split("-")[0] } | ForEach-Object {
    $latestZipFile = $_.Group | Sort-Object -Property { [version]($_.Name.Split("-")[1].Split("_")[0]) } -Descending | Select-Object -First 1
    $latestZipFileName = "$($latestZipFile.Name.Split("-")[0])-LATEST_installer.zip"
    $latestZipFilePath = Join-Path -Path $installerZipsDir -ChildPath $latestZipFileName
    Copy-Item -Path $latestZipFile.FullName -Destination $latestZipFilePath -Force
}


