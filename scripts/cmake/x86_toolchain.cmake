set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Use native compilers
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

# OpenSSL specific configuration
set(OPENSSL_TARGET "linux-x86_64")

# Not cross-compiling for x86 on x86, so set to FALSE
set(CMAKE_CROSSCOMPILING FALSE)

# Set the system root path to help find dependencies
set(CMAKE_FIND_ROOT_PATH ${CMAKE_BINARY_DIR}/external/install)

# For native compilation, allow finding programs, libraries, and includes on the host
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)

# Toolchain settings
set(CMAKE_INSTALL_RPATH "${CMAKE_BINARY_DIR}/external/install/lib")
set(CMAKE_BUILD_RPATH "${CMAKE_BINARY_DIR}/external/install/lib")

# Ensure RPATH is used during build and install
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
