# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libplist-master)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/xbmc/libplist/archive/master.zip"
    FILENAME "libplist-master.zip"
    SHA512 8f6aa32e342361ee9f6aae62fcda2c7e92c1d26e52356460ff8f69e2a372cea72a03e3d5819b6cfa1672de41212be276f0d4179a1d32986cc9423905aa8a9ab9
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libplist)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libplist/COPYING ${CURRENT_PACKAGES_DIR}/share/libplist/copyright)

# Handle CMake files
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libplist/libplist-config-version.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/libplist-config-version.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libplist/libplist-config.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/libplist-config.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libplist/libplist-release.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/libplist-release.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libplist/libplist.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/libplist.cmake)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/libplist/debug)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libplist/libplist-config-version.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/debug/libplist-config-version.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libplist/libplist-config.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/debug/libplist-config.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libplist/libplist-debug.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/debug/libplist-debug.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libplist/libplist.cmake ${CURRENT_PACKAGES_DIR}/share/libplist/debug/libplist.cmake)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

vcpkg_copy_pdbs()

