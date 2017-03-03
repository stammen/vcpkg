# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-src/harfbuzz-1.3.4)
find_program(NMAKE nmake)

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.4.tar.bz2"
    FILENAME "harfbuzz-1.3.4.tar.bz2"
    SHA512 72027ce64d735f1f7ecabcc78ba426d6155cebd564439feb77cefdfc28b00bfd9f6314e6735addaa90cee1d98cf6d2c0b61f77b446ba34e11f7eb7cdfdcd386a
)
# Harfbuzz only supports in-source builds, so to make sure we get a clean build, we need to re-extract every time
file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-src)
vcpkg_extract_source_archive(${ARCHIVE} ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-src)

if (VCPKG_CMAKE_SYSTEM_NAME STREQUAL WindowsStore)
	vcpkg_apply_patches(
		SOURCE_PATH ${SOURCE_PATH}
		PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-uwp.patch
	)
endif()

file(WRITE ${SOURCE_PATH}/win32/msvc_recommended_pragmas.h "/* I'm expected to exist */")

vcpkg_find_acquire_program(PERL)

file(TO_NATIVE_PATH "${PERL}" PERL_INTERPRETER)
file(TO_NATIVE_PATH "${SOURCE_PATH}" MKENUMS_TOOL_DIR)

file(TO_NATIVE_PATH "${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET}/include" INCLUDE_DIR)
file(TO_NATIVE_PATH "${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET}/debug/lib" LIB_DIR_DBG)
file(TO_NATIVE_PATH "${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET}/lib" LIB_DIR_REL)

set(DEPENDENCIES FREETYPE=1)

vcpkg_execute_required_process(
    COMMAND ${NMAKE} -f Makefile.vc CFG=debug ${DEPENDENCIES} FREETYPE_DIR=${INCLUDE_DIR} ADDITIONAL_LIB_DIR=${LIB_DIR_DBG}
        PREFIX=${MKENUMS_TOOL_DIR} PERL=${PERL_INTERPRETER}
    WORKING_DIRECTORY ${SOURCE_PATH}/win32/
    LOGNAME nmake-build-${TARGET_TRIPLET}-debug
)

vcpkg_execute_required_process(
    COMMAND ${NMAKE} -f Makefile.vc CFG=release ${DEPENDENCIES} FREETYPE_DIR=${INCLUDE_DIR} ADDITIONAL_LIB_DIR=${LIB_DIR_REL}
        PREFIX=${MKENUMS_TOOL_DIR} PERL=${PERL_INTERPRETER}
    WORKING_DIRECTORY ${SOURCE_PATH}/win32/
    LOGNAME nmake-build-${TARGET_TRIPLET}-release
)

file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/debug" NATIVE_PACKAGES_DIR_DBG)

set( ENV{LDFLAGS} /APPCONTAINER "WindowsApp.lib" )
 
vcpkg_execute_required_process(
    COMMAND ${NMAKE} -f Makefile.vc CFG=debug ${DEPENDENCIES} PREFIX=${NATIVE_PACKAGES_DIR_DBG} install
    WORKING_DIRECTORY ${SOURCE_PATH}/win32/
    LOGNAME nmake-install-${TARGET_TRIPLET}-debug
)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}" NATIVE_PACKAGES_DIR_REL)

set( ENV{LDFLAGS} /APPCONTAINER "WindowsApp.lib" )
vcpkg_execute_required_process(
    COMMAND ${NMAKE} -f Makefile.vc CFG=release ${DEPENDENCIES} PREFIX=${NATIVE_PACKAGES_DIR_REL} install
    WORKING_DIRECTORY ${SOURCE_PATH}/win32/
    LOGNAME nmake-install-${TARGET_TRIPLET}-release
)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/harfbuzz/COPYING ${CURRENT_PACKAGES_DIR}/share/harfbuzz/copyright)
