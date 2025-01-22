# Set the minimum required version of CMake for this project.
cmake_minimum_required(VERSION 3.13)

# Set the project name.
project(s3_file_uploader)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Option and message settings.
option(TRACE OFF)
set(CMAKE_INSTALL_MESSAGE LAZY)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error") # Disable warnings as errors.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")

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

set(TARGET_LINK_LIBRARIES
)

# Hello S3 List Objects
add_executable(${PROJECT_NAME} main.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE ${TARGET_INCLUDE_DIRS})
target_link_directories(${PROJECT_NAME} PRIVATE ${TARGET_LINK_DIRS})
target_link_libraries(${PROJECT_NAME} ${TARGET_LINK_LIBRARIES})