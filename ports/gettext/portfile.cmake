# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

#Based on https://github.com/winlibs/gettext

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/gettext-0.19)
vcpkg_download_distfile(ARCHIVE
    URLS "http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.tar.gz"
    FILENAME "gettext-0.19.tar.gz"
    SHA512 a5db035c582ff49d45ee6eab9466b2bef918e413a882019c204a9d8903cb3770ddfecd32c971ea7c7b037c7b69476cf7c56dcabc8b498b94ab99f132516c9922
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists_libintl.txt DESTINATION ${SOURCE_PATH}/gettext-runtime)
file(RENAME ${SOURCE_PATH}/gettext-runtime/CMakeLists_libintl.txt ${SOURCE_PATH}/gettext-runtime/CMakeLists.txt)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/libgnuintl.h DESTINATION ${SOURCE_PATH}/gettext-runtime/intl)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/config.h DESTINATION ${SOURCE_PATH}/gettext-runtime)

vcpkg_apply_patches(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/0001-Fix-macro-definitions.patch"
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0002-Fix-UWP.patch
)


vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()

file(COPY ${SOURCE_PATH}/gettext-runtime/intl/libgnuintl.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(RENAME ${CURRENT_PACKAGES_DIR}/include/libgnuintl.h ${CURRENT_PACKAGES_DIR}/include/libintl.h)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/gettext)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/gettext/COPYING ${CURRENT_PACKAGES_DIR}/share/gettext/copyright)

vcpkg_copy_pdbs()