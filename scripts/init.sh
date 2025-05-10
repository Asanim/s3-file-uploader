#!/bin/bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo apt-get update
sudo apt-get install -y build-essential cmake libcurl4-openssl-dev libssl-dev uuid-dev zlib1g-dev

# Download and extract the ARM toolchain to the build directory

mkdir -p $SCRIPT_PATH/../build
cd $SCRIPT_PATH/../build

mkdir -p ${HOME}/toolchains

echo "Downloading and extracting the ARM toolchain..."
curl -LO https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz
tar xvf arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz -C ${HOME}/toolchains

echo "Downloading and extracting the ARM64 toolchain..."
curl -LO https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
tar xvf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C ${HOME}/toolchains

# Install gdk - greengrass development kit
pip3 install -U git+https://github.com/aws-greengrass/aws-greengrass-gdk-cli.git@v1.6.2

cd $SCRIPT_PATH
curl -LO https://www.amazontrust.com/repository/AmazonRootCA1.pem