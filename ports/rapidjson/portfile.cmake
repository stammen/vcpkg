#header-only library
include(vcpkg_common_functions)
SET(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/rapidjson-1.0.2)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/miloyip/rapidjson/archive/v1.0.2.zip"
    FILENAME "rapidjson-v1.0.2.zip"
    SHA512 b1bbcdf8b56fdc054416d0d024cd472fe511c0c15cb133513bb6575b05089ef5685fb5b1797d6e6c22475088b34659064241846a6a360cc461d74b6b079815a3
)
vcpkg_extract_source_archive(${ARCHIVE})

# Put the licence file where vcpkg expects it
file(COPY ${SOURCE_PATH}/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/rapidjson)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/rapidjson/license.txt ${CURRENT_PACKAGES_DIR}/share/rapidjson/copyright)

# Copy the rapidjson header files
file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR} FILES_MATCHING PATTERN "*.h")
vcpkg_copy_pdbs()
