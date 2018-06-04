# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/msm
    REF boost-1.65.0
    SHA512 afd459045afc8bf0c808e16f08990cf4735eb0688a4f752864225225f67b9d40b0bfae73f7230199482d5b3e18327c3c078447bfded5839338bf3535227bff74
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
