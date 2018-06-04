# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/units
    REF boost-1.65.0
    SHA512 0a1b47d3ee0a5e1256ab47e38e0eb1a93cd1587b56adfb77961443c46c092061dc652ad776dbb0cdf0b6a095af1e4a39a554b627b85918a62d0e5aeaeee80dac
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
