#!/bin/bash

# Validate the COMPONENT_VERSION parameter
if [ $# -ne 1 ]; then
    echo "Usage: $0 COMPONENT_VERSION"
    exit 1
fi
# Get the path of the script
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define environment variables
export COMPONENT_VERSION="$1"
export AWS_REGION=ap-southeast-2
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
export BUCKET_NAME="greengrass-artifacts"
export BUCKET_NAME_FULL="greengrass-artifacts-${AWS_REGION}-${AWS_ACCOUNT_ID}"
export COMPONENT_NAME="com.example.s3-file-uploader"
export COMPONENT_AUTHOR="Asanim"
export BUILD_SCRIPT_PATH="$SCRIPT_PATH/build.sh"

# Remove any existing build artifacts
rm -rf $SCRIPT_PATH/../build/greengrass-build
rm -rf $SCRIPT_PATH/../build/s3-file-uploader_*.deb

# Create directories if they don't exist
mkdir -p $SCRIPT_PATH/../build/greengrass-build/recipes $SCRIPT_PATH/../build/greengrass-build/artifacts

cd $SCRIPT_PATH/../build

# Create 'recipe.json' using environment variables
envsubst < "$SCRIPT_PATH/templates/recipe.json.template" > "recipe.json"

# Create 'gdk-config.json' using environment variables
envsubst < "$SCRIPT_PATH/templates/gdk-config.json.template" > "gdk-config.json"

# Build and publish the component
echo "Building the component"
gdk component build

# Hotfix
cp recipe.json $SCRIPT_PATH/../build/greengrass-build/recipes/recipe.json

echo "Publish the component"
gdk component publish