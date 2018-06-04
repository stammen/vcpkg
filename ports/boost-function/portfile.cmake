# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/function
    REF boost-1.65.0
    SHA512 967828508250f165cbd732a64db5ec293fb4df560c73d44a0dfa9432585af7b967ac2c445da71ca5e0dec1e4d643515fad2fadd82824d466ab9056779647375f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
