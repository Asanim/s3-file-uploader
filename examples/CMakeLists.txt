# Set the minimum required version of CMake for this project.
cmake_minimum_required(VERSION 3.13)

# Set the project name.
project(hello_s3)

# Set service components and C++ standard.
set(SERVICE_COMPONENTS s3)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Option and message settings.
option(TRACE OFF)
set(CMAKE_INSTALL_MESSAGE LAZY)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error") # Disable warnings as errors.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")

# Include the AWS SDK CMake script.
include(${CMAKE_SOURCE_DIR}/scripts/cmake/zlib.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/cmake/curl.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/cmake/aws-sdk-cpp.cmake) # This is to build the dependencies for sentinel vision ai.

find_package(OpenSSL REQUIRED)

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/external/install/lib")
message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

set(AWSSDK_ROOT_DIR "${CMAKE_BINARY_DIR}/external/install")
message(STATUS "AWSSDK_ROOT_DIR: ${AWSSDK_ROOT_DIR}")

set(TARGET_INCLUDE_DIRS
    ${CMAKE_BINARY_DIR}/external/install/include/ # Include for Curl
    ${CMAKE_BINARY_DIR}/external/install/usr/local/include/ # Include for Curl
    ${OPENSSL_ROOT_DIR}/include # OpenSSL includes
    ${PISTACHE_INCLUDE_DIR} # for rapid json
)
set(TARGET_LINK_DIRS
    ${CMAKE_BINARY_DIR}/external/install/lib/ # LibCurl
    ${CMAKE_BINARY_DIR}/external/install/usr/local/lib/ # LibCurl
    ${OPENSSL_ROOT_DIR}/lib # OpenSSL libs
)

set(TARGET_LINK_LIBRARIES
    aws-c-cal
    aws-c-compression
    aws-c-mqtt
    aws-c-s3
    curl
    ssl
    crypto
    aws-c-http
    aws-c-common
    aws-c-event-stream
    aws-cpp-sdk-core
    z
    aws-c-auth
    aws-c-io
    aws-cpp-sdk-s3
    aws-c-sdkutils
    s2n
    aws-checksums
    aws-crt-cpp
)

# Hello S3 List Objects
add_executable(greengrass_certificates_upload_file greengrass_certificates_upload_file.cpp common.cpp)
add_dependencies(greengrass_certificates_upload_file aws-sdk-cpp libpistache)
target_include_directories(greengrass_certificates_upload_file PRIVATE ${TARGET_INCLUDE_DIRS})
target_link_directories(greengrass_certificates_upload_file PRIVATE ${TARGET_LINK_DIRS})
target_link_libraries(greengrass_certificates_upload_file ${TARGET_LINK_LIBRARIES})

# Add a message to indicate the successful configuration of the project.
message(STATUS "Configured hello_s3 target successfully.")
