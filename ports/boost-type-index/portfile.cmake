# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_index
    REF boost-1.65.0
    SHA512 66efd68cb4cd6310c45b9ed1eefba4b0270844491b5c946db84c3989a782d342efb8c242b98ee2ca506eb0d19e5f23e380d12a14fc143fc77f54a005b900de4c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
