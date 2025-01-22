# C++ AWS S3 File Directory Uploader for Greengrass

## Motivation

This repository was created to address the need for handling multimedia uploads in a purely C++ application running as an AWS Greengrass component. While a similar implementation exists in Python (see [AWS Labs S3 File Uploader](https://github.com/awslabs/aws-greengrass-labs-s3-file-uploader)), this project demonstrates how to achieve the same functionality using C++ with the AWS SDK.

For further reference, examples using the AWS SDK can be found in the official documentation repository: [AWS SDK Examples](https://github.com/awsdocs/aws-doc-sdk-examples/tree/main).

In theory, after performing the key exchange it is possible to write any application using the AWS SDK as a Greengrass component, as long as the edge device is configured with the necessary IAM permissions

This repository aims to serve as a guide for those with a similar use case or anyone looking to integrate the AWS SDK with AWS Greengrass using C++.

---

## Features and Goals

- **AWS SDK Integration**: Demonstrates the use of the AWS SDK in a Greengrass-compatible C++ application.
- **S3 Upload System**: Builds a simple system to upload files from a directory to an S3 bucket.
- **Multi-Architecture Builds**: Provides a system for building the application for multiple architectures.
- **Command-Line Usage**: Offers a command-line interface for configuring and running the uploader.
- **GitHub Pipelines**: Implements automated CI/CD workflows for testing and releases.
- **Releases**: Distributes pre-built binaries for supported architectures.
- **Unit Testing and Logging**:
  - Utilizes `gtest` for unit testing.
  - Employs `glog` for robust logging and argument parsing.

---

## Prerequisites

1. **AWS CLI**:
   - Ensure the AWS CLI is installed and configured with the necessary credentials.
   - Register your AWS credentials using the following command:
     ```bash
     aws configure
     ```

2. **AWS Greengrass**:
   - Set up an AWS Greengrass environment with an edge device configured with the necessary IAM permissions to access S3.

3. **AWS SDK**:
   - Install and configure the AWS SDK for C++.

4. **Development Tools**:
   - CMake (for build configuration)
   - A compatible C++ compiler (e.g., GCC, Clang, or MSVC)

---

## Deployment

### Deploying Locally

1. Clone this repository:
   ```bash
   git clone https://github.com/Asanim/s3-file-uploader.git
   cd s3-file-uploader
   ```

2. Build the application using CMake:
   ```bash
   mkdir build && cd build
   cmake ..
   make
   ```

3. Run the application:
   ```bash
   ./s3_file_uploader --bucket <S3_BUCKET_NAME> --directory <DIRECTORY_PATH>
   ```

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