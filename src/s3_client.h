#ifndef S3_CLIENT_H_
#define S3_CLIENT_H_

#include <aws/core/Aws.h>
#include <aws/core/auth/AWSCredentialsProvider.h>
#include <aws/core/auth/AWSCredentialsProviderChain.h>
#include <aws/core/utils/memory/stl/AWSStringStream.h>
#include <aws/greengrass/GreengrassCoreIpcClient.h>
#include <aws/s3/S3Client.h>
#include <aws/s3/model/GetObjectRequest.h>
#include <aws/s3/model/PutObjectRequest.h>
#include <curl/curl.h>

#include <chrono>
#include <fstream>
#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <utility>
#include <vector>

class S3Client {
 public:
  /// \brief Constructor for the S3Client class.
  ///
  /// Initializes the S3Client with the specified parameters, sets up the AWS SDK,
  /// and prepares the client for file uploads.
  ///
  /// \param thing_name The AWS IoT thing name associated with this device.
  /// \param aws_region The AWS region for the S3 service.
  /// \param credential_endpoint The endpoint URL for requesting temporary AWS credentials.
  /// \param watch_directory The directory to monitor for files to upload.
  S3Client::S3Client(const std::string &thing_name, const std::string &aws_region,
                     const std::string &credential_endpoint, const std::string &watch_directory);

  /// \brief Destructor for the S3Client class.
  ///
  /// Cleans up resources, stops the upload thread, and shuts down the AWS SDK.
  ~S3Client();

 private:
  /// \brief Thread function that monitors a directory for files to upload.
  ///
  /// Continuously watches the specified directory for new files,
  /// uploads them to S3, and deletes them after successful upload.
  /// If uploads fail, files are left in place for retrying later.
  void MainThread();

  /// \brief Indicates whether the device has internet connectivity and valid AWS credentials.
  ///
  /// When false, uploads are postponed until connectivity is restored.
  std::atomic<bool> is_connected_ = false;

  /// \brief Flag indicating whether the AWS SDK has been initialized.
  ///
  /// Prevents multiple initialization of the SDK, which can cause issues.
  static bool is_sdk_initalized_;

  /// \brief Thread that handles the file upload process.
  ///
  /// Runs the MainThread method in a separate thread.
  std::unique_ptr<std::thread> upload_thread_;

  /// \brief Flag indicating whether the upload thread should continue running.
  ///
  /// Used to safely terminate the thread when the S3Client is destroyed.
  std::atomic<bool> is_running_ = true;

  /// \brief Client for interacting with AWS S3 service.
  ///
  /// Handles all S3 operations, including file uploads.
  std::shared_ptr<Aws::S3::S3Client> s3_client_;

  /// \brief Provider for AWS credentials used to authenticate with S3.
  ///
  /// Supplies access key, secret key, and session token.
  std::shared_ptr<Aws::Auth::AWSCredentialsProvider> credentials_provider_;

  /// \brief Default S3 bucket name for file uploads.
  ///
  /// Target bucket where files will be uploaded.
  std::string bucket_name_ = "";

  /// \brief AWS region for the S3 service.
  ///
  /// Region where the S3 bucket is located.
  std::string aws_region_ = "";

  /// \brief The AWS IoT thing name associated with this device.
  ///
  /// Used to identify the device and construct S3 object paths.
  std::string thing_name_ = "";

  /// \brief Endpoint URL for requesting temporary AWS credentials.
  ///
  /// Used to obtain credentials for S3 access.
  std::string credential_endpoint_ = "";

  /// \brief Path to the CA certificate bundle file.
  ///
  /// Used for secure HTTPS connections.
  const std::string kCACertificatePath = "/etc/ssl/certs/ca-bundle.crt";

  /// \brief Path to the IoT thing certificate.
  ///
  /// Used for authenticating with AWS IoT.  
  const std::string kThingCertPath = "/greengrass/v2/thingCert.crt";

  /// \brief Path to the private key associated with the thing certificate.
  ///
  /// Used for authenticating with AWS IoT.
  const std::string kPrivateKeyPath = "/greengrass/v2/privKey.key";

  /// \brief Path to the AWS IoT root CA certificate.
  ///
  /// Used for verifying the AWS IoT endpoint.
  const std::string kRootCAPath = "/greengrass/v2/rootCA.pem";

  /// \brief Directory to monitor for files to upload.
  ///
  /// All files appearing in this directory will be uploaded to S3.
  std::string watch_directory_;

  /// \brief AWS SDK options for configuring logging and other settings.
  Aws::SDKOptions sdk_options_;

};

#endif  // S3_CLIENT_H_
