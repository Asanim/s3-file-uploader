set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm-linux-gnueabihf)

set(TOOL_PATH "${HOME}/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf")
set(TARGET_CROSS "arm-linux-gnueabihf")

set(CMAKE_C_COMPILER ${TARGET_CROSS}-gcc)
set(CMAKE_CXX_COMPILER ${TARGET_CROSS}-g++)
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES  ${HOME}/toolchains/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/arm-linux-gnueabihf/include/c++)
# set(QEMU_ARM "qemu-arm")

set(CMAKE_FIND_ROOT_PATH ${TOOL_PATH} ${CMAKE_BINARY_DIR}/external/install)
set(CMAKE_FIND_ROOT_PATH_PROGRAM_MODE NEVER)

# Adjust the default behavior of the FIND_XXX() commands:
# search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Toolchain settings
set(CMAKE_INSTALL_RPATH "${CMAKE_SYSROOT}/lib:${CMAKE_BINARY_DIR}/external/install/lib")
set(CMAKE_BUILD_RPATH "${CMAKE_SYSROOT}/lib:${CMAKE_BINARY_DIR}/external/install/lib")

# Ensure RPATH is used during build and install
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
