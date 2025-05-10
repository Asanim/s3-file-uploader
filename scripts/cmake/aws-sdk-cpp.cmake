include(ExternalProject)

message(STATUS "Added aws-sdk-cpp to external submodules")

ExternalProject_Add(aws-sdk-cpp
    GIT_REPOSITORY https://github.com/aws/aws-sdk-cpp
    GIT_TAG 1.11.434
    GIT_SUBMODULES_RECURSE 1
    PATCH_COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_BINARY_DIR}/external/aws-sdk-cpp/src/crt/aws-crt-cpp git apply ${CMAKE_SOURCE_DIR}/scripts/cmake/patches/aws-sdk-crt-variant.patch
    CMAKE_ARGS
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DENABLE_TESTING=OFF
    -DAUTORUN_UNIT_TESTS=OFF
    -DBUILD_ONLY=s3
    -DBUILD_SHARED_LIBS=ON
    -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/external/install
    -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/external/install
    -DCMAKE_BUILD_TYPE=Release
    -DUSE_OPENSSL=ON

    # Zlib settings
    -DZLIB_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libz.so
    -DZLIB_INCLUDE_DIR=${CMAKE_BINARY_DIR}/external/install/include/

    # libcurl settings
    -DCURL_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libcurl.so
    -DCURL_INCLUDE_DIR=${CMAKE_BINARY_DIR}/external/install/include/

    # libcrypto settings
    -Dcrypto_INCLUDE_DIR=${CMAKE_BINARY_DIR}/external/install/include
    -Dcrypto_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libcrypto.so.3
    -Dcrypto_STATIC_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libcrypto.a
    -Dcrypto_SHARED_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libcrypto.so.3
    -DOPENSSL_CRYPTO_LIBRARY=${CMAKE_BINARY_DIR}/external/install/lib/libcrypto.so.3
    -DOPENSSL_INCLUDE_DIR=${CMAKE_BINARY_DIR}/external/install/include

    PREFIX ${CMAKE_BINARY_DIR}/external/aws-sdk-cpp/prefix
    TMP_DIR ${CMAKE_BINARY_DIR}/external/aws-sdk-cpp/tmp
    STAMP_DIR ${CMAKE_BINARY_DIR}/external/aws-sdk-cpp/stamp
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/external/aws-sdk-cpp/download
    SOURCE_DIR ${CMAKE_BINARY_DIR}/external/aws-sdk-cpp/src
    BINARY_DIR ${CMAKE_BINARY_DIR}/external/aws-sdk-cpp/build
    INSTALL_DIR ${CMAKE_BINARY_DIR}/external/install
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 0
)

add_dependencies(aws-sdk-cpp zlib libcurl openssl)
