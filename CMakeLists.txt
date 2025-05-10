# Set the minimum required version of CMake for this project.
cmake_minimum_required(VERSION 3.13)

# Set the project name.
project(s3-file-uploader)

# Set C++17 as the required standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Option and message settings.
option(TRACE OFF)
set(CMAKE_INSTALL_MESSAGE LAZY)


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error") # Disable warnings as errors.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")

# Include the AWS SDK CMake script.
include(${CMAKE_SOURCE_DIR}/scripts/cmake/zlib.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/cmake/curl.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/cmake/openssl.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/cmake/aws-sdk-cpp.cmake) # This is to build the dependencies for sentinel vision ai.
include(${CMAKE_SOURCE_DIR}/scripts/cmake/rapidjson.cmake)
include(${CMAKE_SOURCE_DIR}/scripts/cmake/cpack.cmake)

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/external/install/lib")
message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

# Packaging options
if(NOT DEFINED CPACK_GENERATOR)
    set(CPACK_GENERATOR "DEB")
endif()

add_subdirectory(src)
