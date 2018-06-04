# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/polygon
    REF boost-1.65.0
    SHA512 e6dd12fa8e3fbec31ebfe50d35ce0724cc92fadee941f32076879bdca94348919eb64e5ddcc35492c9f9bdfc7fcb8a2b15a9af7379997aac827887d6eae1c3d0
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
