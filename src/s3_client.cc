#include "s3_client.h"

#include <fstream>

#include "key_exchange.h"

using namespace Aws;
using namespace Aws::Auth;

bool S3Client::is_sdk_initalized_ = false;

S3Client::S3Client(const std::string &thing_name, const std::string &aws_region, const std::string &credential_endpoint,
                   const std::string &watch_directory)
    : thing_name_(thing_name),
      aws_region_(aws_region),
      credential_endpoint_(credential_endpoint),
      watch_directory_(watch_directory) {

  // Initialize the AWS SDK only once
  if (!is_sdk_initalized_) {
    sdk_options_.loggingOptions.logLevel = Aws::Utils::Logging::LogLevel::Fatal;
    Aws::InitAPI(sdk_options_);

    is_sdk_initalized_ = true;
  }

  // Start the upload thread
  is_running_ = true;
  upload_thread_ = std::make_unique<std::thread>(&S3Client::MainThread, this);
}

S3Client::~S3Client() {
  if (upload_thread_ != nullptr) {
    if (upload_thread_->joinable()) {
      is_running_ = false;
      upload_thread_->join();
    } else {
      std::cerr << "MainThread is not joinable";
    }
  }
  Aws::ShutdownAPI(sdk_options_); // Should only be called once.
}

void S3Client::MainThread() {
  // Keep the main thread alive and process files
  while (is_running_) {
    // if there is no internet connection, sleep for 3 minutes before checking again
    if (!is_connected_) {
      std::this_thread::sleep_for(std::chrono::seconds(3 * 60));
      is_connected_ = (CreateClient() == sv::Status::kSuccess);

      continue;
    }

    try {
      // Scan the watch directory for files
      for (const auto &entry : std::filesystem::directory_iterator(watch_directory_)) {
        if (entry.is_regular_file()) {
          std::string file_path = entry.path().string();
          // Default bucket - this could be made configurable
          std::string bucket_name = "default-bucket";

          // Sleep for milliseconds to ensure the file is completely written
          std::this_thread::sleep_for(std::chrono::milliseconds(100));

          // Upload the file
          if (auto result = S3UploadHandler::UploadFile(bucket_name, file_path); result == sv::Status::kSuccess) {
            std::string message = "Successfully uploaded file: " + file_path + ". Deleting file.";

            // Delete the file after successful upload
            std::filesystem::remove(file_path);

            // Queue success message
            auto message_payload = ConvertFileUploadRequestStatusToJson(
                file_path, "Upload successful", sv::Status::kSuccess, std::chrono::system_clock::now());
          } else if (result == sv::Status::kInvalidParameter) {
            std::string error_message = "File path was invalid: " + file_path;
            std::cerr << error_message;
            throw std::invalid_argument(error_message);
          } else {
            std::string error_message = "Failed to upload file: " + file_path;
            std::cerr << error_message;

            // File remains in the directory for retry on next iteration

            is_connected_ = false;
            std::this_thread::sleep_for(std::chrono::seconds(30));
            throw std::invalid_argument(error_message);
          }
        }
      }

      // Wait before checking the directory again
      std::this_thread::sleep_for(std::chrono::seconds(1));

    } catch (const std::exception &e) {
      std::cerr << "Exception in MainThread: " << e.what();
      // Wait before trying again
      std::this_thread::sleep_for(std::chrono::seconds(5));
    }
  }
}

int S3Client::CreateClient() {

  try {
    // Configure S3 client
    Aws::Client::ClientConfiguration client_config;
    client_config.region = kAWSRegion;
    client_config.caFile = kCACertificatePath;

    credentials_provider_ = GetAWSCredentialsProviderFromCertificates(thing_name_);
    if (credentials_provider_ == nullptr) {
      std::cerr << "Failed to get AWS credentials provider from certificates";
      return -1;
    }
    // Initialize the AWS SDK
    s3_client_ = std::make_shared<Aws::S3::S3Client>(credentials_provider_, nullptr, client_config);
  } catch (const Aws::Client::AWSError<Aws::S3::S3Errors> &e) {
    std::cerr << "Failed to create S3 client: " << e.GetMessage();  // GetMessage() gives the error message
    return -1;
  } catch (const std::exception &e) {
    // Catch any other standard exceptions
    std::cerr << "Failed to create S3 client: " << e.what();
    return -1;
  }
  return 0;
}