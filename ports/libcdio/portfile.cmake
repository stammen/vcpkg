# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libcdio-0.9.3-win32-vc140)
vcpkg_download_distfile(ARCHIVE
    URLS "http://mirrors.kodi.tv/build-deps/win32/libcdio-0.9.3-win32-vc140.7z"
    FILENAME "libcdio-0.9.3-win32-vc140.7z"
    SHA512 2a0acbb92dc28a76edc5f6d586c8489fe037456b9a9a6c94073493ecece5b8ee73f76d22be0c18d46b37c8feb98c754cc21abde6139dc32c019d306b7c281f6a
)
vcpkg_extract_source_archive(${ARCHIVE})



# Handle copyright
file(COPY ${CMAKE_CURRENT_LIST_DIR}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libcdio)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libcdio/LICENSE ${CURRENT_PACKAGES_DIR}/share/libcdio/copyright)

file(COPY ${SOURCE_PATH}/project/BuildDependencies/include/cdio DESTINATION ${CURRENT_PACKAGES_DIR}/include)

#since these libs are NOT UWP libs, copy them to a different dir
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/BuildDependencies)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/BuildDependencies/lib)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/BuildDependencies/bin)
file(COPY ${SOURCE_PATH}/project/BuildDependencies/lib DESTINATION ${CURRENT_PACKAGES_DIR}/BuildDependencies)
file(COPY ${SOURCE_PATH}/system/ DESTINATION ${CURRENT_PACKAGES_DIR}/BuildDependencies/bin)

