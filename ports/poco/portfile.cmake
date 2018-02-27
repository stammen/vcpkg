include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pocoproject/poco
    REF poco-1.8.1-release
    SHA512 ca57b30c10fc4e611dbdd90c7e36db34b8cb9a7dae675dc8aed37457a26d3433080caf26eaace85adf8d6a6ad7945c49f7c66f274b26fe9cc0c7d5107be3828e
    HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/config_h.patch
        ${CMAKE_CURRENT_LIST_DIR}/find_pcre.patch
        ${CMAKE_CURRENT_LIST_DIR}/foundation-public-include-pcre.patch
        ${CMAKE_CURRENT_LIST_DIR}/fix-static-internal-pcre.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" POCO_STATIC)

if("mysql" IN_LIST FEATURES)
    # enabling MySQL support
    set(MYSQL_INCLUDE_DIR "${CURRENT_INSTALLED_DIR}/include/mysql")
    set(MYSQL_LIB "${CURRENT_INSTALLED_DIR}/lib/libmysql.lib")
    set(MYSQL_LIB_DEBUG "${CURRENT_INSTALLED_DIR}/debug/lib/libmysql.lib")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPOCO_STATIC=${POCO_STATIC}
        -DENABLE_SEVENZIP=ON
        -DENABLE_TESTS=OFF
        -DPOCO_UNBUNDLED=ON # OFF means: using internal copy of sqlite, libz, pcre, expat, ...
        -DMYSQL_INCLUDE_DIR=${MYSQL_INCLUDE_DIR}
    OPTIONS_RELEASE
        -DMYSQL_LIB=${MYSQL_LIB}
    OPTIONS_DEBUG
        -DMYSQL_LIB=${MYSQL_LIB_DEBUG}
)

vcpkg_install_cmake()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/cpspc.exe ${CURRENT_PACKAGES_DIR}/tools/cpspc.exe)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/f2cpsp.exe ${CURRENT_PACKAGES_DIR}/tools/f2cpsp.exe)

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE 
        ${CURRENT_PACKAGES_DIR}/bin
        ${CURRENT_PACKAGES_DIR}/debug/bin)
else()
    file(REMOVE 
        ${CURRENT_PACKAGES_DIR}/bin/cpspc.pdb
        ${CURRENT_PACKAGES_DIR}/bin/f2cpsp.pdb
        ${CURRENT_PACKAGES_DIR}/debug/bin/cpspc.exe
        ${CURRENT_PACKAGES_DIR}/debug/bin/cpspc.pdb
        ${CURRENT_PACKAGES_DIR}/debug/bin/f2cpsp.exe
        ${CURRENT_PACKAGES_DIR}/debug/bin/f2cpsp.pdb)
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/poco)

# copy license
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/poco)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/poco/LICENSE ${CURRENT_PACKAGES_DIR}/share/poco/copyright)
