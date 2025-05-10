#include <aws/core/Aws.h>
#include <aws/s3/S3Client.h>
#include <aws/s3/model/ListObjectsV2Request.h>
#include <aws/s3/model/ListObjectsV2Result.h>
#include <aws/core/auth/AWSCredentialsProviderChain.h>
#include <iostream>
#include "common.h"

using namespace Aws;
using namespace Aws::Auth;
using namespace Aws::S3;

int main(int argc, char **argv)
{
    if (argc != 3)
    {
        std::cerr << "Usage: " << argv[0] << " <bucket_name>" << " <thing_name>" << std::endl;
        return 1;
    }

    const Aws::String bucket_name = argv[1];
    const Aws::String thing_name = argv[2];

    Aws::SDKOptions options;
    Aws::InitAPI(options); // Should only be called once.
    {
        Aws::Client::ClientConfiguration clientConfig;
        clientConfig.region = "ap-southeast-2";               // Specify the AWS region
        clientConfig.caFile = "/etc/ssl/certs/ca-bundle.crt"; // Path to CA cert if needed

        // Use default AWS credentials provider chain
        auto provider = GetAWSCredentialsProviderFromCertificates(thing_name);

        auto creds = provider->GetAWSCredentials();
        if (creds.IsEmpty())
        {
            std::cerr << "Failed authentication" << std::endl;
        }

        S3Client s3Client(provider, nullptr, clientConfig);
        // Create ListObjectsV2 request
        Aws::S3::Model::ListObjectsV2Request request;
        request.SetBucket(bucket_name);

        // Send the request
        auto outcome = s3Client.ListObjectsV2(request);

        if (outcome.IsSuccess())
        {
            std::cout << "Listing contents of bucket " << bucket_name << ":\n";
            const auto &objects = outcome.GetResult().GetContents();
            for (const auto &object : objects)
            {
                std::cout << " - " << object.GetKey() << std::endl;
            }
        }
        else
        {
            std::cerr << "Failed to list objects in bucket " << bucket_name
                      << ": " << outcome.GetError().GetMessage() << std::endl;
            return 1;
        }
    }
    Aws::ShutdownAPI(options); // Should only be called once.
    return 0;
}
