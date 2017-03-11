# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/taglib-e36a9cabb9882e61276161c23834d966d62073b7)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/taglib/taglib/archive/e36a9cabb9882e61276161c23834d966d62073b7.zip"
    FILENAME "e36a9cabb9882e61276161c23834d966d62073b7.zip"
    SHA512 bb8fb5251b0afb1f17c7c8ffd0badfcda96ee443641658251b33513b227bd4814474ef0ee02481aa2c601661dbab5b473171fad6ebdd61e6d12cbd49619b03bd
)
vcpkg_extract_source_archive(${ARCHIVE})

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
file(COPY ${SOURCE_PATH}/COPYING.MPL DESTINATION ${CURRENT_PACKAGES_DIR}/share/taglib)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/taglib/COPYING.MPL ${CURRENT_PACKAGES_DIR}/share/taglib/copyright)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/tag.lib ${CURRENT_PACKAGES_DIR}/debug/lib/tagd.lib)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/tag_c.lib ${CURRENT_PACKAGES_DIR}/debug/lib/tag_cd.lib)

vcpkg_copy_pdbs()
