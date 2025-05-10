#ifndef COMMON_H_
#define COMMON_H_

#include <aws/core/auth/AWSCredentialsProvider.h>
#include <aws/core/auth/AWSCredentialsProviderChain.h>
#include <aws/core/http/HttpClientFactory.h>
#include <aws/core/http/HttpResponse.h>
#include <aws/core/utils/memory/stl/AWSStringStream.h>
#include <curl/curl.h>

#include <fstream>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

#include "rapidjson/document.h"
#include "rapidjson/error/en.h"

/// \brief The path to the CA certificate bundle.
const char kCACertificatePath[] = "/etc/ssl/certs/ca-bundle.crt";
/// \brief The path to the thing certificate.
const char kThingCertPath[] = "/greengrass/v2/thingCert.crt";
/// \brief The path to the private key.
const char kPrivateKeyPath[] = "/greengrass/v2/privKey.key";
/// \brief The path to the root CA certificate.
const char kRootCAPath[] = "/greengrass/v2/rootCA.pem";
/// \brief AWS region
const char kAWSRegion[] = "";
/// \brief Credential endpoint
const char kCredentialEndpoint[] = "";

///
/// \brief Get the access keys from the token exchange result
///
/// \param response
/// \param access_key_id
/// \param secret_access_key
/// \param session_token
/// \return int
///
int AccessKeysFromTokenExchangeResult(const std::string_view response, std::string *access_key_id,
                                         std::string *secret_access_key, std::string *session_token);

///
/// \brief Request credentials from Greengrass
///
/// \param cert_path The path to the client certificate
/// \param key_path The path to the private key
/// \param ca_path The path to the CA certificate
/// \param thing_name The name of the device associated with Greengrass
/// \param access_key_id The access key ID
/// \param secret_access_key The secret access key
/// \param session_token The session token
/// \return int
///
int RequestCredentials(const std::string &endpoint_url, const std::string &cert_path, const std::string &key_path,
                          const std::string &ca_path, const std::string &thing_name, std::string *access_key_id,
                          std::string *secret_access_key, std::string *session_token);

///
/// \brief Write callback function
///
/// \param contents The contents of the response
/// \param size The size of the response
/// \param num_members The number of members
/// \param user_data The user data
/// \return size_t
///
size_t WriteCallback(char *contents, size_t size, size_t num_members, std::string *user_data);

///
/// \brief Get AWS credentials provider from certificates
///
/// \return std::shared_ptr<Aws::Auth::AWSCredentialsProvider>
///
std::shared_ptr<Aws::Auth::AWSCredentialsProvider> GetAWSCredentialsProviderFromCertificates(
    const std::string &thing_name);

#endif  // COMMON_H_
