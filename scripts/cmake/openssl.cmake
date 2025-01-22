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
    PREFIX ${CMAKE_BINARY_DIR}/external/openssl/prefix
    TMP_DIR ${CMAKE_BINARY_DIR}/external/openssl/tmp
    STAMP_DIR ${CMAKE_BINARY_DIR}/external/openssl/stamp
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/external/openssl/download
    SOURCE_DIR ${CMAKE_BINARY_DIR}/external/openssl/src
    BUILD_IN_SOURCE TRUE
    CONFIGURE_COMMAND 
        ./Configure 
        linux-generic32 
        --prefix=${CMAKE_BINARY_DIR}/external/install 
        --openssldir=${CMAKE_BINARY_DIR}/external/install/ssl 
        CFLAGS="-I${CMAKE_BINARY_DIR}/external/install/include" 
        LDFLAGS="-L${CMAKE_BINARY_DIR}/external/install/lib -Wl,-rpath,${CMAKE_BINARY_DIR}/external/install/lib"
    INSTALL_COMMAND make install
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 0
)