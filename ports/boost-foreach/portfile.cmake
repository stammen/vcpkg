# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/foreach
    REF boost-1.65.0
    SHA512 b7a8355e92a449deafe67da3af7684ef8b5553f8c8c1e62fa393f687c9db898e4391853d32113b5075e92d9b3e8d4473c97e0c03cdc9f3ea6af619de050c09e6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
