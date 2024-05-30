#!/bin/bash

# Variables
# GITHUB_REPO_URL="https://github.com/username/repo.git" #  URL of the GitHub repository.
# CLONE_DIR="repo" # directory where the repository will be cloned.
# ZIP_FILE_NAME="repo.zip" # name of the zip file to be created.
# DEST_DIR="/path/to/destination/folder" # destination directory where the zip file will be moved.

# Source the configuration file
source config_sh

# Step 1: Clone the GitHub repository
if [ -d "$CLONE_DIR" ]; then
  echo "Directory $CLONE_DIR already exists. Pulling latest changes..."
  cd $CLONE_DIR
  git pull
  cd ..
else
  echo "Cloning the repository..."
  git clone $GITHUB_REPO_URL $CLONE_DIR
fi

# Step 2: Zip the repository
echo "Creating a zip file..."
zip -r $ZIP_FILE_NAME $CLONE_DIR

# Step 3: Move the zip file to the destination folder
echo "Moving the zip file to $DEST_DIR..."
mv $ZIP_FILE_NAME $DEST_DIR

echo "Done!"