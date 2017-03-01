# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/fribidi-1a6935cd8cd7d907fb3c5f3bcae174bee727c83d)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/behdad/fribidi/archive/1a6935cd8cd7d907fb3c5f3bcae174bee727c83d.zip"
    FILENAME "1a6935cd8cd7d907fb3c5f3bcae174bee727c83d.zip"
    SHA512 ebb395fbb74935f5be257c61ce515ca15e6be6f98c412d8ac0be81f58f40b54eb8433f0d35c9a81dd6591d1691ca139205a296fcc75115efc797a768c36a85e3
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# Handle copyright
#file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libfribidi)
#file(RENAME ${CURRENT_PACKAGES_DIR}/share/libfribidi/LICENSE ${CURRENT_PACKAGES_DIR}/share/libfribidi/copyright)
