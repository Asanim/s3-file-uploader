include(ExternalProject)

message(STATUS "Added RapidJSON to external submodules")
# ------------------------------------------------------------------------------
# RapidJSON
# ------------------------------------------------------------------------------
ExternalProject_Add(
    rapidjson
    GIT_REPOSITORY https://github.com/Tencent/rapidjson
    GIT_SHALLOW 1
    GIT_TAG v1.1.0
    CMAKE_ARGS
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_SOURCE_DIR}/scripts/cmake/arm_toolchain.cmake
    -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/external/install
    -DRAPIDJSON_BUILD_DOC=OFF
    -DRAPIDJSON_BUILD_EXAMPLES=OFF
    -DRAPIDJSON_BUILD_TESTS=OFF
    -DRAPIDJSON_BUILD_CXX11=OFF

    PREFIX ${CMAKE_BINARY_DIR}/external/rapidjson/prefix
    TMP_DIR ${CMAKE_BINARY_DIR}/external/rapidjson/tmp
    STAMP_DIR ${CMAKE_BINARY_DIR}/external/rapidjson/stamp
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/external/rapidjson/download
    SOURCE_DIR ${CMAKE_BINARY_DIR}/external/rapidjson/src
    BINARY_DIR ${CMAKE_BINARY_DIR}/external/rapidjson/build
    UPDATE_DISCONNECTED 1
    BUILD_ALWAYS 0
)
