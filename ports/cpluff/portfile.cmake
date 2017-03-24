# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/c-pluff-master)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/jlehtine/c-pluff/archive/master.zip"
    FILENAME "c-pluff-master.zip"
    SHA512 c05e489b19fcf0a5a4cb835c043f432e578b6722567a2e11fac42f39d9b8f38006d9053f7a2944a95d1f44d09ac5f6cac83c007efcebeec66b231e27641acb68
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/cpluffdef.h DESTINATION ${SOURCE_PATH}/libcpluff)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/dirent.c DESTINATION ${SOURCE_PATH}/libcpluff)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/dirent.h DESTINATION ${SOURCE_PATH}/libcpluff)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-uwp.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    # PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYRIGHT.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpluff)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/cpluff//COPYRIGHT.txt ${CURRENT_PACKAGES_DIR}/share/cpluff/copyright)
