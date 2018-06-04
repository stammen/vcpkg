# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/proto
    REF boost-1.65.0
    SHA512 936ef590f323261b7b3b5103b93c7b14564144e77d4b020d90d53ef73ab44732c1dcee3ddc455a8e74109a34b6d958418f353298157cdab2aec198f91540694f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
