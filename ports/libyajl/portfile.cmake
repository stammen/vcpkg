# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/yajl-f4b2b1af87483caac60e50e5352fc783d9b2de2d)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/lloyd/yajl/archive/f4b2b1af87483caac60e50e5352fc783d9b2de2d.zip"
    FILENAME "f4b2b1af87483caac60e50e5352fc783d9b2de2d.zip"
    SHA512 36c8f4e5fac215590a29dc2c3e9bbeda6dcf10a756b57f33738462310b496493e420ca1e152d1db7eb9eb7843ab7642641c6c03c159fa2b7ef0c155935d51a03
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_build_cmake()

# Manual install
message(STATUS "Installing")

set(RELDIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/yajl-2.0.1)
set(DBGDIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/yajl-2.0.1)
message(****RELDIR: ${RELDIR})

file(COPY ${RELDIR}/include/yajl DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${DBGDIR}/lib/Debug/yajl_s.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib RENAME yajld.lib)
file(INSTALL ${RELDIR}/lib/Release/yajl_s.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib RENAME yajl.lib)


# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libyajl)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libyajl/COPYING ${CURRENT_PACKAGES_DIR}/share/libyajl/copyright)
