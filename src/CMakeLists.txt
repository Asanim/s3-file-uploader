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

# Find required AWS packages
find_package(AWSSDK REQUIRED COMPONENTS s3 core)

# Set source files
set(SOURCES
    key_exchange.cc
    s3_client.cc
    main.cpp
)

# Create executable target
add_executable(s3_file_uploader ${SOURCES})

# Add include directories
target_include_directories(s3_file_uploader PRIVATE
    ${TARGET_INCLUDE_DIRS}
    ${AWSSDK_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Set link directories
target_link_directories(s3_file_uploader PRIVATE
    ${TARGET_LINK_DIRS}
    ${AWSSDK_LIB_DIR}
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
