include(vcpkg_common_functions)

set(LIBGEOTIFF_VERSION 1.4.2)
set(LIBGEOTIFF_HASH 059c6e05eb0c47f17b102c7217a2e1636e76d622c4d1bdcf0bd89fb3505f3130bffa881e21c73cfd2ca0d6863b81322f85784658ba3539b53b63c3a8f38d1deb)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libgeotiff-${LIBGEOTIFF_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-${LIBGEOTIFF_VERSION}.tar.gz"
    FILENAME "libgeotiff-${LIBGEOTIFF_VERSION}.tar.gz"
    SHA512 ${LIBGEOTIFF_HASH})

vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/0001-Updates-to-CMake-configuration-to-align-with-other-C.patch"
            "${CMAKE_CURRENT_LIST_DIR}/0002-Fix-directory-output.patch"
            "${CMAKE_CURRENT_LIST_DIR}/0003-Fix-cmake-TIFF-detection.patch"
            "${CMAKE_CURRENT_LIST_DIR}/0004-Fix-libxtiff-installation.patch"
            "${CMAKE_CURRENT_LIST_DIR}/0005-Control-shared-library-build-with-option.patch"
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  set(BUILD_SHARED_LIBS ON)
else()
  set(BUILD_SHARED_LIBS OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
            -DWITH_TIFF=ON
            -DWITH_PROJ4=ON
            -DWITH_ZLIB=ON
            -DWITH_JPEG=ON
    OPTIONS_RELEASE -DWITH_UTILITIES=ON
    OPTIONS_DEBUG   -DWITH_UTILITIES=OFF
)

vcpkg_build_cmake()
vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libgeotiff RENAME copyright)

file(GLOB GEOTIFF_UTILS ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(INSTALL ${GEOTIFF_UTILS} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/libgeotiff/)
file(REMOVE ${GEOTIFF_UTILS})
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/libgeotiff)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin ${CURRENT_PACKAGES_DIR}/bin)
endif()
