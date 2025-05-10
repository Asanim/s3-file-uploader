#include <iostream>
#include <string>
#include <csignal>
#include "s3_client.h"

// Signal flag for graceful termination
volatile sig_atomic_t g_running = 1;

// Signal handler for Ctrl+C
void signal_handler(int signal) {
    g_running = 0;
}

int main(int argc, char **argv)
{
    if (argc != 5)
    {
        std::cerr << "Usage: " << argv[0] << " <bucket_name> <thing_name> <aws_region> <watch_directory>" << std::endl;
        return 1;
    }

    // Set up signal handling for graceful termination
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);

    const std::string bucket_name = argv[1];
    const std::string thing_name = argv[2];
    const std::string aws_region = argv[3];
    const std::string watch_directory = argv[4];
    
    // Credential endpoint can be constructed based on the region
    const std::string credential_endpoint = "https://iot." + aws_region + ".amazonaws.com";

    try {
        std::cout << "Initializing S3 client to monitor directory: " << watch_directory << std::endl;
        std::cout << "Using bucket: " << bucket_name << ", thing_name: " << thing_name << std::endl;
        
        // Initialize the S3 client
        S3Client s3_client(thing_name, aws_region, credential_endpoint, watch_directory);
        
        // Upload any existing files and monitor for new ones
        std::cout << "Starting to watch directory for files to upload..." << std::endl;
        
        // Main application loop - keep running until signal received
        while (g_running) {
            // Sleep to avoid consuming CPU
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
        
        std::cout << "Shutting down..." << std::endl;
    }
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}
