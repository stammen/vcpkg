# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/ublas
    REF boost-1.65.0
    SHA512 4f1c112b1ed7afe7a94266d80ca47fc13c7f7ac7dbcde5d3dd06d1855a09f7154b8803b925b4d28b5d3ba21f72e1247554fe46a756d9d10337b02ca1c8c3d81d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
