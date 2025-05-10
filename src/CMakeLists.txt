list(PREPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/external/install/lib")
message(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

set(AWSSDK_ROOT_DIR "${CMAKE_BINARY_DIR}/external/install")
message(STATUS "AWSSDK_ROOT_DIR: ${AWSSDK_ROOT_DIR}")

set(TARGET_INCLUDE_DIRS
    ${CMAKE_BINARY_DIR}/external/install/include/
    ${CMAKE_BINARY_DIR}/external/install/usr/local/include/
)
set(TARGET_LINK_DIRS
    ${CMAKE_BINARY_DIR}/external/install/lib/ # LibCurl
)


# Manually add all the AWS SDK dependency libraries
set(AWSSDK_LIBRARIES
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

# Set source files
set(SOURCES
    key_exchange.cc
    s3_client.cc
    main.cpp
)


# Create executable target
add_executable(s3_file_uploader ${SOURCES})

add_dependencies(s3_file_uploader
    aws-sdk-cpp
)

# Add include directories
target_include_directories(s3_file_uploader PRIVATE
    ${TARGET_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Set link directories
target_link_directories(s3_file_uploader PRIVATE
    ${TARGET_LINK_DIRS}
)

# Link libraries
target_link_libraries(s3_file_uploader
    ${AWSSDK_LIBRARIES}
    aws-cpp-sdk-s3
    aws-cpp-sdk-core
    curl
    z
    ssl
    crypto
)

# Install the executable
install(TARGETS s3_file_uploader
    RUNTIME DESTINATION bin
)
