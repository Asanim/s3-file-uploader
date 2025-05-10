#include "key_exchange.h"
#include <aws/core/Aws.h>

#include <array>
#include <cstdint>
#include <iterator>
#include <string_view>

#include "rapidjson/document.h"
#include "rapidjson/error/en.h"
#include "rapidjson/rapidjson.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/writer.h"

// Callback function for handling the response
size_t WriteCallback(char *contents, size_t size, size_t num_members, std::string *user_data)
{
  user_data->append(contents, size * num_members);
  return size * num_members;
}

int AccessKeysFromTokenExchangeResult(const std::string_view response, std::string *access_key_id,
                                         std::string *secret_access_key, std::string *session_token)
{
  rapidjson::Document document;
  rapidjson::ParseResult ok = document.Parse(response.data());
  try
  {
    if (document.HasParseError())
    {
      std::cerr << "Could not parse JSON, malformed " + std::string(GetParseError_En(ok.Code())) + "()" +
                       std::to_string(ok.Offset()) + ") :" + std::string(response.data());
      return -1;
    }

    if (document.HasMember("credentials") && document["credentials"].IsObject())
    {
      const rapidjson::Value &credentials = document["credentials"];
      if (credentials.HasMember("accessKeyId") && credentials["accessKeyId"].IsString())
      {
        *access_key_id = credentials["accessKeyId"].GetString();
      }
      if (credentials.HasMember("secretAccessKey") && credentials["secretAccessKey"].IsString())
      {
        *secret_access_key = credentials["secretAccessKey"].GetString();
      }
      if (credentials.HasMember("sessionToken") && credentials["sessionToken"].IsString())
      {
        *session_token = credentials["sessionToken"].GetString();
      }
      return 0;
    }
    else
    {
      return -1;
    }
  }
  catch (const std::invalid_argument &e)
  {
    return -1;
  }
  return 0;
}

int RequestCredentials(const std::string &endpoint_url, const std::string &cert_path, const std::string &key_path,
                          const std::string &ca_path, const std::string &thing_name, std::string *access_key_id,
                          std::string *secret_access_key, std::string *session_token)
{
  CURL *curl;
  CURLcode res;
  std::string response;

  curl_global_init(CURL_GLOBAL_DEFAULT);
  curl = curl_easy_init();

  if (curl)
  {
    curl_easy_setopt(curl, CURLOPT_URL, endpoint_url.c_str());

    curl_easy_setopt(curl, CURLOPT_SSLCERT, cert_path.c_str());
    curl_easy_setopt(curl, CURLOPT_SSLKEY, key_path.c_str());
    curl_easy_setopt(curl, CURLOPT_CAINFO, ca_path.c_str());

    struct curl_slist *headers = nullptr;
    std::string header = "x-amzn-iot-thingname:" + thing_name;
    headers = curl_slist_append(headers, header.c_str());
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);

    res = curl_easy_perform(curl);

    if (res != CURLE_OK)
    {
      curl_slist_free_all(headers);
      curl_easy_cleanup(curl);
      curl_global_cleanup();
      return -1;
    }

    // Cleanup
    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);
    curl_global_cleanup();


    AccessKeysFromTokenExchangeResult(response, access_key_id, secret_access_key, session_token);

    return 0;
  }

  curl_global_cleanup();
  return -1;
}

std::shared_ptr<Aws::Auth::AWSCredentialsProvider> GetAWSCredentialsProviderFromCertificates(
    const std::string &thing_name, Aws::Client::ClientConfiguration &clientConfig)
{
  std::shared_ptr<Aws::Auth::AWSCredentialsProvider> credentials_provider;

  Aws::SDKOptions options;
  options.loggingOptions.logLevel = Aws::Utils::Logging::LogLevel::Fatal;
  Aws::InitAPI(options); 

  std::string access_key_id;
  std::string secret_access_key;
  std::string session_token;

  if (int success = RequestCredentials(kCredentialEndpoint, kThingCertPath, kPrivateKeyPath, clientConfig.caFile,
                                          thing_name, &access_key_id, &secret_access_key, &session_token);
      success == 0)
  {

    credentials_provider = Aws::MakeShared<Aws::Auth::SimpleAWSCredentialsProvider>("alloc-tag", access_key_id,
                                                                                    secret_access_key, session_token);
  }
  else
  {
    return nullptr;
  }

  if (auto aws_credentials = credentials_provider->GetAWSCredentials(); aws_credentials.IsEmpty())
  {
    return nullptr;
  }
  return credentials_provider;
}

