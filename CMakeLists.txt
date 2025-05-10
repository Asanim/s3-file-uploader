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

add_subdirectory(src)

# Packaging options
if(NOT DEFINED CPACK_GENERATOR)
    set(CPACK_GENERATOR "DEB")
endif()

# Install additional files for the Debian package
install(FILES ${CMAKE_BINARY_DIR}/src/s3-file-uploader DESTINATION /usr/bin PERMISSIONS WORLD_READ WORLD_EXECUTE OWNER_READ OWNER_EXECUTE GROUP_READ GROUP_EXECUTE)

# Documentation files
install(FILES "${CMAKE_SOURCE_DIR}/README.md"
    DESTINATION "/usr/share/doc/${PROJECT_NAME}"
    COMPONENT documentation)

# Certificates
install(FILES
    ${CMAKE_SOURCE_DIR}/scripts/AmazonRootCA1.pem
    DESTINATION /etc/ssl/certs/
)

# Library files
install(FILES
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-auth.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-auth.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-cal.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-cal.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-common.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-common.so.1
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-common.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-compression.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-compression.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-event-stream.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-event-stream.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-checksums.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-checksums.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-http.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-http.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-io.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-io.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-cpp-sdk-core.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-cpp-sdk-s3.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-crt-cpp.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-s3.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-s3.so.0unstable
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-s3.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-sdkutils.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libaws-c-sdkutils.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libcrypto.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libcrypto.so.3
    ${CMAKE_BINARY_DIR}/external/install/lib/libcurl.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libcurl.so.4
    ${CMAKE_BINARY_DIR}/external/install/lib/libcurl.so.4.8.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libs2n.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libs2n.so.1
    ${CMAKE_BINARY_DIR}/external/install/lib/libs2n.so.1.0.0
    ${CMAKE_BINARY_DIR}/external/install/lib/libssl.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libssl.so.3
    ${CMAKE_BINARY_DIR}/external/install/lib/libz.so
    ${CMAKE_BINARY_DIR}/external/install/lib/libz.so.1
    ${CMAKE_BINARY_DIR}/external/install/lib/libz.so.1.3.1
    DESTINATION /usr/lib
)

