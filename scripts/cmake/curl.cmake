include(ExternalProject)

message(STATUS "Added curl to external submodules")
# ------------------------------------------------------------------------------
# curl
# ------------------------------------------------------------------------------

ExternalProject_Add(
    libcurl
    URL https://curl.se/download/curl-${CURL_VERSION}.tar.gz
    PREFIX ${CMAKE_BINARY_DIR}/external/curl/prefix
    TMP_DIR ${CMAKE_BINARY_DIR}/external/curl/tmp
    STAMP_DIR ${CMAKE_BINARY_DIR}/external/curl/stamp
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/external/curl/download
    SOURCE_DIR ${CMAKE_BINARY_DIR}/external/curl/src
    BINARY_DIR ${CMAKE_BINARY_DIR}/external/curl/build
    CMAKE_ARGS
    -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
    -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/external/install
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS=OFF
    -DBUILD_CURL_EXE=OFF
    -DBUILD_TESTING=OFF
    -DCURL_STATICLIB=ON
    -DHTTP_ONLY=ON
    -DCMAKE_USE_OPENSSL=OFF
    -DCMAKE_USE_LIBSSH2=OFF
    -DCURL_ZLIB=OFF

    -DOPENSSL_ROOT_DIR=${CMAKE_BINARY_DIR}/external/install/
    -DOPENSSL_INCLUDE_DIR=${CMAKE_BINARY_DIR}/external/install/include
    -DOPENSSL_CRYPTO_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libcrypto.so
    -DOPENSSL_SSL_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libssl.so

    BUILD_BYPRODUCTS ${CURL_STATIC_LIB}
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 0
)

