# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/pcre-8.39)
vcpkg_download_distfile(ARCHIVE
    URLS "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.zip" "https://downloads.sourceforge.net/project/pcre/pcre/8.39/pcre-8.39.zip"
    FILENAME "pcre-8.39.zip"
    SHA512 14e6336fe603b7110ba9d54a92af8449bbd4a82fe33d14bc912a048336fc90686464354141316c7890e80e7501af88f657cb7247de6717674e80ba044a279a00
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-uwp.patch
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0002-Kodi-debug-build-defines.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS -DPCRE_BUILD_TESTS=NO
            -DPCRE_BUILD_PCREGREP=NO
            -DPCRE_BUILD_PCRE32=YES
            -DPCRE_BUILD_PCRE16=YES
            -DPCRE_BUILD_PCRE8=YES
            -DPCRE_SUPPORT_JIT=YES
            -DPCRE_SUPPORT_UTF=YES
            -DPCRE_SUPPORT_UNICODE_PROPERTIES=YES
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

foreach(FILE ${CURRENT_PACKAGES_DIR}/include/pcre.h ${CURRENT_PACKAGES_DIR}/include/pcreposix.h)
    file(READ ${FILE} PCRE_H)
    if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        string(REPLACE "defined(PCRE_STATIC)" "1" PCRE_H "${PCRE_H}")
    else()
        string(REPLACE "defined(PCRE_STATIC)" "0" PCRE_H "${PCRE_H}")
    endif()
    file(WRITE ${FILE} "${PCRE_H}")
endforeach()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pcre)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pcre/COPYING ${CURRENT_PACKAGES_DIR}/share/pcre/copyright)

vcpkg_copy_pdbs()