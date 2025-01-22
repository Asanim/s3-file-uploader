include(ExternalProject)

message(STATUS "Added openssl to external submodules")
# ------------------------------------------------------------------------------
# openssl
# ------------------------------------------------------------------------------
ExternalProject_Add(
    openssl
    GIT_REPOSITORY https://github.com/openssl/openssl.git
    GIT_TAG master
    GIT_SHALLOW 1
    CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/external/install
    PREFIX ${CMAKE_BINARY_DIR}/external/openssl/prefix
    TMP_DIR ${CMAKE_BINARY_DIR}/external/openssl/tmp
    STAMP_DIR ${CMAKE_BINARY_DIR}/external/openssl/stamp
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/external/openssl/download
    SOURCE_DIR ${CMAKE_BINARY_DIR}/external/openssl/src
    BINARY_DIR ${CMAKE_BINARY_DIR}/external/openssl/build
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 0
)