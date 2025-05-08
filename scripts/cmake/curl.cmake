include(ExternalProject)

# curl version
set(CURL_VERSION "7.88.1" CACHE STRING "curl version")

# Get OS and architecture information
if(CMAKE_CROSSCOMPILING)
    set(CURL_TARGET_SYSTEM ${CMAKE_SYSTEM_NAME})
else()
    set(CURL_TARGET_SYSTEM ${CMAKE_HOST_SYSTEM_NAME})
endif()

# Set up paths
set(CURL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/curl)
set(CURL_INSTALL_DIR ${CURL_PREFIX}/install)
set(CURL_INCLUDE_DIR ${CURL_INSTALL_DIR}/include)
set(CURL_LIB_DIR ${CURL_INSTALL_DIR}/lib)

# Set up library names with platform-specific extensions
if(CURL_TARGET_SYSTEM STREQUAL "Windows")
    set(CURL_STATIC_LIB "${CURL_LIB_DIR}/libcurl.lib")
    set(CURL_IMPORT_LIB "${CURL_LIB_DIR}/libcurl_imp.lib")
    set(CURL_SHARED_LIB "${CURL_LIB_DIR}/libcurl.dll")
else()
    set(CURL_STATIC_LIB "${CURL_LIB_DIR}/libcurl.a")
    set(CURL_SHARED_LIB "${CURL_LIB_DIR}/libcurl${CMAKE_SHARED_LIBRARY_SUFFIX}")
endif()

# Build options for curl
set(CURL_CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=${CURL_INSTALL_DIR}
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

)

# Add toolchain file if crosscompiling
if(CMAKE_TOOLCHAIN_FILE)
    list(APPEND CURL_CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE})
endif()

# Additional compiler flags
if(CMAKE_C_FLAGS)
    list(APPEND CURL_CMAKE_ARGS -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS})
endif()

if(CMAKE_CXX_FLAGS)
    list(APPEND CURL_CMAKE_ARGS -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS})
endif()

# Define the external project
ExternalProject_Add(libcurl
    URL https://curl.se/download/curl-${CURL_VERSION}.tar.gz
    PREFIX ${CURL_PREFIX}
    CMAKE_ARGS ${CURL_CMAKE_ARGS}
    BUILD_BYPRODUCTS ${CURL_STATIC_LIB}
)

# Create imported library
add_library(curl::libcurl STATIC IMPORTED GLOBAL)
set_target_properties(curl::libcurl PROPERTIES
    IMPORTED_LOCATION ${CURL_STATIC_LIB}
    INTERFACE_INCLUDE_DIRECTORIES ${CURL_INCLUDE_DIR}
)
add_dependencies(curl::libcurl libcurl)

# Export variables for the parent scope
set(CURL_INCLUDE_DIRS ${CURL_INCLUDE_DIR} CACHE PATH "Path to curl include directory")
set(CURL_LIBRARIES ${CURL_STATIC_LIB} CACHE FILEPATH "Path to curl library")
