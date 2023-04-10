# PowerShell Script for Zipping and Grouping Files

## Description
This script is designed to group files by their extension, create a zip archive for each group, and store them in a specified directory. The script is written in PowerShell and can be easily modified to fit different needs.

## Usage
1. Download the `zip-and-group.ps1` file and save it to your desired directory.
2. Open PowerShell and navigate to the directory where you saved the script.
3. Run the script with the following command: `.\zip-and-group.ps1 -SourceDirectory "C:\path\to\source\directory" -DestinationDirectory "C:\path\to\destination\directory"`

## Parameters
- `-SourceDirectory`: Specifies the directory where the script should look for files to group and zip.
- `-DestinationDirectory`: Specifies the directory where the zipped files should be stored. If the directory does not exist, it will be created.

## Example
.\zip-and-group.ps1 -SourceDirectory "C:\Users\JohnDoe\Downloads" -DestinationDirectory "C:\Users\JohnDoe\ZippedDownloads"

This will group all files in the `Downloads` directory by their extension, create a zip archive for each group, and store them in the `ZippedDownloads` directory.

## Notes
- The script will not zip files that are already zipped.
- The script will skip files that cannot be zipped due to permissions or other issues.
- The script will overwrite existing zip files in the destination directory.
