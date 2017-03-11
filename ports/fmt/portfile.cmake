#if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
#    message(STATUS "Warning: Dynamic building not supported yet. Building static.")
#    set(VCPKG_LIBRARY_LINKAGE static)
#endif()
include(vcpkg_common_functions)

set(VCPKG_LIBRARY_LINKAGE static)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/fmt-3.0.1)
vcpkg_download_distfile(ARCHIVE_FILE
    URLS "https://github.com/fmtlib/fmt/archive/3.0.1.tar.gz"
    FILENAME "fmt-3.0.1.tar.gz"
    SHA512 daf5dfb2fe63eb611983fa248bd2182c6202cf1c4f0fc236f357040fce8e87ad531cdf59090306bb313ea333d546e516f467b385e05094e696d0ca091310aad6
)
vcpkg_extract_source_archive(${ARCHIVE_FILE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-UWP.patch
)

# Copy the fmt header files
file(INSTALL ${SOURCE_PATH}/fmt DESTINATION ${CURRENT_PACKAGES_DIR}/include FILES_MATCHING PATTERN "*.h")
file(INSTALL ${SOURCE_PATH}/fmt DESTINATION ${CURRENT_PACKAGES_DIR}/include FILES_MATCHING PATTERN "*.cc")

file(INSTALL ${SOURCE_PATH}/LICENSE.rst DESTINATION ${CURRENT_PACKAGES_DIR}/share/fmt RENAME copyright)

vcpkg_copy_pdbs()


