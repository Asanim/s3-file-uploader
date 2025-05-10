# C++ AWS S3 File Directory Uploader for Greengrass

## Motivation

This repository was created to address the need for handling multimedia uploads in a purely C++ application running as an AWS Greengrass component. While a similar implementation exists in Python (see [AWS Labs S3 File Uploader](https://github.com/awslabs/aws-greengrass-labs-s3-file-uploader)), this project demonstrates how to achieve the same functionality using C++ with the AWS SDK.

Alternatively, this application may be run from a greengrass device standalone. It uses the greengrass certificates to interact with s3. Note: this application shall have the same permissions as the greengrass device it is run on. Hence, if the greengrass device does not have access to a S3 bucket this application shall not either. Refer to the following documentation for how to enable access: [Device Service Role](https://docs.aws.amazon.com/greengrass/v2/developerguide/device-service-role.html)

For further reference, examples using the AWS SDK can be found in the official documentation repository: [AWS SDK Examples](https://github.com/awsdocs/aws-doc-sdk-examples/tree/main).

In theory, after performing the key exchange it is possible to write any application using the AWS SDK as a Greengrass component, as long as the edge device is configured with the necessary IAM permissions

This repository aims to serve as a guide for those with a similar use case or anyone looking to integrate the AWS SDK with AWS Greengrass using C++.

## Further Reading

1. [AWS SDK for C++ S3 Examples](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/examples-s3.html)
2. [AWS IoT Greengrass V2 Device Authentication](https://docs.aws.amazon.com/greengrass/v2/developerguide/device-auth.html)
3. [AWS IoT Greengrass V2 Component Recipe Reference](https://docs.aws.amazon.com/greengrass/v2/developerguide/component-recipe-reference.html)


## Notes

- Greengrass component packages are typically installed to the `packages-unarchived` folder, which is managed by the Greengrass core software.
- In this case, instead of using the default Greengrass package installation location, we install a Debian package (`.dpkg`) directly to the system root directory (`/`).
- Installing to the system root means the package and its files are available system-wide, outside of the Greengrass-managed environment.
- Note how the recipe does not require any specific Greengrass permissions. It does not specifically interact with Greengrass core, only with the certificates of Greengrass itself. Hence, care must be taken when assigning IAM permissions to the host device.

## Features and Goals

- **AWS SDK Integration**: Demonstrates the use of the AWS SDK in a Greengrass-compatible C++ application.
- **S3 Upload System**: Builds a simple system to upload files from a directory to an S3 bucket.
- **Multi-Architecture Builds**: Provides a system for building the application for multiple architectures.
- **Command-Line Usage**: Offers a command-line interface for configuring and running the uploader.
- **GitHub Pipelines**: Implements automated CI/CD workflows for testing and releases.
- **Releases**: Distributes pre-built binaries for common architectures.
- **Unit Testing and Logging**:
  - Utilizes `gtest` for unit testing.
  - Employs `glog` for robust logging and argument parsing.

## Building 

1. Clone this repository:
   ```bash
   git clone https://github.com/Asanim/s3-file-uploader.git
   cd s3-file-uploader
   ```

2. Build the application using CMake:
   ```bash
   mkdir build && cd build
   cmake -DCMAKE_TOOLCHAIN_FILE=$(pwd)/../scripts/cmake/arm_toolchain.cmake  -DCMAKE_BUILD_TYPE=Debug ..
   make -j$(nproc -1)
   ```

3. Run the application:
   ```bash
   ./s3_file_uploader --bucket <S3_BUCKET_NAME> --directory <DIRECTORY_PATH>
   ```

### Deploying Locally

### Deploying in the Cloud

1. Package the application as a Greengrass component.
2. Define the component configuration file (`recipe.json`) to specify the component's dependencies, lifecycle, and runtime configuration.
3. Deploy the component via the Greengrass console or the AWS CLI.

---

## Usage

Run the uploader from the command line with the following syntax:

```bash
./s3_file_uploader --bucket <S3_BUCKET_NAME> --directory <DIRECTORY_PATH>
```

**Arguments**:
- `--bucket`: The name of the S3 bucket where files will be uploaded.
- `--directory`: The path to the directory containing files to upload.

---

## Development and Testing

### Unit Tests

This project uses `gtest` for unit testing. To run tests:

1. Build the test suite:
   ```bash
   mkdir build && cd build
   cmake -DBUILD_TESTS=ON ..
   make
   ```

2. Execute the tests:
   ```bash
   ./tests
   ```

### Logging

Logging is handled by `glog` to ensure clear and actionable logs for debugging and operational monitoring.

---

## CI/CD with GitHub Actions

This repository includes a GitHub Actions workflow for:
- Building the application for multiple architectures.
- Running unit tests.
- Packaging and releasing binaries.

---

## Releases

Pre-built binaries for supported architectures will be provided with each release. Check the [Releases](https://github.com/Asanim/s3-file-uploader/releases) page for available downloads.

---

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it as needed.