include(ExternalProject)

message(STATUS "Added libcurl to external submodules")
# ------------------------------------------------------------------------------
# libcurl
# ------------------------------------------------------------------------------
ExternalProject_Add(
    libcurl
    GIT_REPOSITORY https://github.com/curl/curl
    GIT_SHALLOW 1
    GIT_TAG curl-8_0_1
    CMAKE_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/external/install
        -DZLIB_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libz.so
        -DZLIB_INCLUDE_DIR=${CMAKE_BINARY_DIR}/external/install/include
        -DOPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR}
        -DOPENSSL_INCLUDE_DIR=${OPENSSL_ROOT_DIR}/include
        -DOPENSSL_CRYPTO_LIBRARY=${OPENSSL_ROOT_DIR}/lib/libcrypto.so
        -DOPENSSL_SSL_LIBRARY=${OPENSSL_ROOT_DIR}/lib/libssl.so
    PREFIX ${CMAKE_BINARY_DIR}/external/libcurl/prefix
    TMP_DIR ${CMAKE_BINARY_DIR}/external/libcurl/tmp
    STAMP_DIR ${CMAKE_BINARY_DIR}/external/libcurl/stamp
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/external/libcurl/download
    SOURCE_DIR ${CMAKE_BINARY_DIR}/external/libcurl/src
    BINARY_DIR ${CMAKE_BINARY_DIR}/external/libcurl/build
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 0
)

add_dependencies(libcurl zlib)
