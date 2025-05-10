#!/bin/bash

# Check if the number of command-line arguments is not equal to 2
if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 COMPONENT-NAME COMPONENT-VERSION"
  exit 1
fi

# Assign command-line arguments to variables
COMPONENT_NAME=$1
VERSION=$2

# Get the path of the script
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Recompile the component
cd $SCRIPT_PATH/../build
cmake .. && make -j$(nproc -1) && cpack

# Copy the renamed archive to greengrass-build
mkdir -p $SCRIPT_PATH/../build/greengrass-build/artifacts/$COMPONENT_NAME/$VERSION/
cp $SCRIPT_PATH/../build/s3-file-uploader_*.deb $SCRIPT_PATH/../build/greengrass-build/artifacts/$COMPONENT_NAME/$VERSION/
