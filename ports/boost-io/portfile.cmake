# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/io
    REF boost-1.65.0
    SHA512 869200db12c6d8f7ee01e17be8463ded6f6f0bb903b8015a8f76e6c14e8f1414013715dc5f3e93fcb8f3d543ad9814b7362c8d3ab412a4826a1ef596b8405036
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
