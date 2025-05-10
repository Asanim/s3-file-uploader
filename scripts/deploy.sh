#!/bin/bash

# Validate the COMPONENT_VERSION parameter
if [ $# -ne 1 ]; then
    echo "Usage: $0 COMPONENT_VERSION"
    exit 1
fi

# Define environment variables
export COMPONENT_VERSION="$1"
export AWS_REGION=ap-southeast-2
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
export BUCKET_NAME="greengrass-artifacts"
export BUCKET_NAME_FULL="greengrass-artifacts-${AWS_REGION}-${AWS_ACCOUNT_ID}"
export COMPONENT_NAME="com.example.s3-file-uploader"
export COMPONENT_AUTHOR="Asanim"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $SCRIPT_PATH/../build

# Create 'recipe.json' using environment variables
envsubst < "$SCRIPT_PATH/templates/recipe.json.template" > "recipe.json"
cat recipe.json

# Create 'gdk-config.json' using environment variables
envsubst < "$SCRIPT_PATH/templates/gdk-config.json.template" > "gdk-config.json"
cat gdk-config.json

# Build and publish the component
echo "Building the component"
gdk component build

echo "Publish the component"
gdk component publish