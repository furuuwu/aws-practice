# PowerShell script to clone a GitHub repo, zip it, and move it to a destination folder

# Load config
$config = Get-Content -Path "config_ps1" | ConvertFrom-StringData

# Variables from config
$GITHUB_REPO_URL = $config.GITHUB_REPO_URL
$CLONE_DIR = $config.CLONE_DIR
$ZIP_FILE_NAME = $config.ZIP_FILE_NAME
$DEST_DIR = $config.DEST_DIR

# Debug output
Write-Output "GITHUB_REPO_URL: $GITHUB_REPO_URL"
Write-Output "CLONE_DIR: $CLONE_DIR"
Write-Output "ZIP_FILE_NAME: $ZIP_FILE_NAME"
Write-Output "DEST_DIR: $DEST_DIR"

# Full paths
$clonePath = Join-Path -Path $PWD -ChildPath $CLONE_DIR
$zipFilePath = Join-Path -Path $PWD -ChildPath $ZIP_FILE_NAME
$destDirPath = Join-Path -Path $PWD -ChildPath $DEST_DIR

# Step 1: Clone the GitHub repository
if (Test-Path -Path $clonePath) {
    Write-Output "Directory $clonePath already exists. Pulling latest changes..."
    Set-Location -Path $clonePath
    git pull
    Set-Location -Path $PWD
} else {
    Write-Output "Cloning the repository..."
    git clone $GITHUB_REPO_URL $clonePath
}

# Step 2: Zip the repository
if (Test-Path -Path $clonePath) {
    Write-Output "Creating a zip file..."
    Add-Type -AssemblyName "System.IO.Compression.FileSystem"
    [System.IO.Compression.ZipFile]::CreateFromDirectory($clonePath, $zipFilePath)
} else {
    Write-Output "Error: Cloned directory not found!"
    exit 1
}

# Step 3: Move the zip file to the destination folder
if (Test-Path -Path $zipFilePath) {
    Write-Output "Moving the zip file to $destDirPath..."
    Move-Item -Path $zipFilePath -Destination $destDirPath
} else {
    Write-Output "Error: Zip file not found!"
    exit 1
}

Write-Output "Done!"
Set-Location -Path ..