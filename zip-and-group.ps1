Add-Type -AssemblyName System.IO.Compression.FileSystem

$excluded = @("*.zip")
$folderPath = "F:\Interface\Qlik\0003\In\"
$DocFiles = Get-ChildItem $folderPath -Recurse -Exclude $excluded | Where-Object {!$_.PSIsContainer}
$timestamp=Get-Date -Format "yyyyMMdd"
# Count the files
$fileCountBeforeZip = 0
$fileCountAfterZip = 0

# Use a dictionary to group matching files
$matchedFiles = @{}
foreach ($fileName in $DocFiles)
{
    $splitName = $fileName.Name.Split("-_")
    $splitCount = $splitName.Count
    $matchedString = $splitName | Where-Object {$_ -match 'SLSRPT|INVRPT'}
    if ($matchedString)
    {
        $matchedIndex = [array]::IndexOf($splitName, $matchedString)
        if ($matchedIndex -lt ($splitCount - 1))
        {
            $fileNameAfterSplit = $matchedString + "_" + $splitName[$matchedIndex+1]
        }
        else
        {
            $fileNameAfterSplit = $matchedString
        }

        if ($matchedFiles.ContainsKey($fileNameAfterSplit))
        {
            # Eşleşen dosya adı zaten sözlükte varsa, dosya listesine ekle
            $matchedFiles[$fileNameAfterSplit] += ,$($fileName.Name)
            
        }
        else
        {
            # Yeni bir eşleşen dosya adı sözlüğe ekleyin
            $matchedFiles[$fileNameAfterSplit] = @($fileName.Name)
        }
    }
    $fileCountBeforeZip++
}

#foreach ($key in $matchedFiles.Keys) {
#    Write-Host "Anahtar: $key, Değer: $($matchedFiles[$key])"
#}

foreach ($key in $matchedFiles.Keys) {
    $zipFileName = "B24_${key}_${timestamp}.zip"
    # Write-Host "ZipPath: $zipFileName"
    $zipFiles = ($matchedFiles[$key] | ForEach-Object {"$folderPath$_"}) -join " "

    if (($matchedFiles[$key]).Count -eq 1) {
        try{
            Compress-Archive -Path "$zipFiles" -DestinationPath "$folderPath\$zipFileName" -Force
            $fileCountAfterZip += 1
            # Write-Host "zipFiles: $zipFiles"
            # Write-Host "Files has been zipped: $zipFiles => $zipFileName"
        } catch{
            Write-Host "Error: $($_.Exception.Message)"
        }
    } else {
        try{
            $zipPath = "$folderPath\$zipFileName"
            # Write-Host "ZipPath: $zipPath"
            if (Test-Path $zipPath) { Remove-Item $zipPath }
            $zip = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')
            foreach ($file in $matchedFiles[$key]) {
                $fileFullPath = Join-Path $folderPath $file
                # Write-Host "File Full Path: $fileFullPath"
                $entryName = $file -replace [regex]::Escape($key), [regex]::Escape("${key}")
                # Write-Host "EntryName: $entryName"
                [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $fileFullPath, $entryName)
                $fileCountAfterZip += 1
            # Get-ChildItem -Path $folderPath Remove-Item -Force
           }
        } catch{
            Write-Host "Error: $($_.Exception.Message)"
        }
        if ($zip -ne $null)
        {
            $zip.Dispose()
        }

        # Write-Host "Dosyalar ziplendi: $zipFiles => $zipFileName"
    }
}


Write-Host "Total number of files: $fileCountBeforeZip"
Write-Host "Number of zipped files: $fileCountAfterZip"

# Remove all non-zip files
# Get-ChildItem -Path $folderPath -Exclude *.zip | Remove-Item -Force

# Remove only zipped files
foreach ($files in $matchedFiles.Values) {
    foreach ($file in $files) {
        Remove-Item "$folderPath$file" -Force
    }
}