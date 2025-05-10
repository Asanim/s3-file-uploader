set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64-linux-gnu) # armv7a 

set(TOOL_PATH "/tools/toolchains/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu")

set(CROSS_COMPILE_PREFIX "/tools/toolchains/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/aarch64-linux-gnu")
set(TARGET_CROSS "aarch64-linux-gnu")

# /tools/toolchains/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/
string(REPLACE ";" ":" QEMU_LD_PREFIX_STR "${QEMU_LD_PREFIX}")
message(STATUS "QEMU_LD_PREFIX: ${QEMU_LD_PREFIX_STR}")

set(CMAKE_CROSSCOMPILING_EMULATOR qemu-arm -E LD_LIBRARY_PATH=${QEMU_LD_PREFIX_STR})

set(CMAKE_C_COMPILER ${CROSS_COMPILE_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_COMPILE_PREFIX}-g++)
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES /tools/toolchains/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/aarch64-linux-gnu/include/c++)
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
