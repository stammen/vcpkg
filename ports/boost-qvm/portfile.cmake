# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/qvm
    REF boost-1.65.0
    SHA512 a309c82ccbac8bfccf6b18e6bbdcb1acd760528ec1e250cc21c907d5eadc8827273a150f5531e3445e2eb7fb5c595f75a34bdab673a8e7f42c83ceda30b5cd81
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
