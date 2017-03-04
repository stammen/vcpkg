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

if (NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
	message(FATAL_ERROR "This portfile only supports UWP")
endif()

if (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
	set(UWP_PLATFORM  "arm")
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
	set(UWP_PLATFORM  "x64")
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
	set(UWP_PLATFORM  "Win32")
else ()
	message(FATAL_ERROR "Unsupported architecture")
endif()

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-src/harfbuzz-1.3.4)

vcpkg_download_distfile(ARCHIVE
	URLS "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.4.tar.bz2"
	FILENAME "harfbuzz-1.3.4.tar.bz2"
	SHA512 72027ce64d735f1f7ecabcc78ba426d6155cebd564439feb77cefdfc28b00bfd9f6314e6735addaa90cee1d98cf6d2c0b61f77b446ba34e11f7eb7cdfdcd386a
)
# Harfbuzz only supports in-source builds, so to make sure we get a clean build, we need to re-extract every time
file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-src)
vcpkg_extract_source_archive(${ARCHIVE} ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-src)


vcpkg_apply_patches(
	SOURCE_PATH ${SOURCE_PATH}
	PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-uwp.patch
)

file(WRITE ${SOURCE_PATH}/win32/msvc_recommended_pragmas.h "/* I'm expected to exist */")
file(COPY ${CMAKE_CURRENT_LIST_DIR}/make-uwp.bat DESTINATION ${SOURCE_PATH}/win32)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/setVSvars.bat DESTINATION ${SOURCE_PATH}/win32)

vcpkg_find_acquire_program(PERL)

file(TO_NATIVE_PATH "${PERL}" PERL_INTERPRETER)
file(TO_NATIVE_PATH "${SOURCE_PATH}" MKENUMS_TOOL_DIR)

file(TO_NATIVE_PATH "${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET}/include" INCLUDE_DIR)
file(TO_NATIVE_PATH "${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET}/debug/lib" LIB_DIR_DBG)
file(TO_NATIVE_PATH "${VCPKG_ROOT_DIR}/installed/${TARGET_TRIPLET}/lib" LIB_DIR_REL)
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/debug" NATIVE_PACKAGES_DIR_DBG)
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}" NATIVE_PACKAGES_DIR_REL)

#vcpkg_execute_required_process(
#	COMMAND ${CMAKE_CURRENT_LIST_DIR}/setVSvars.bat universal10.0${UWP_PLATFORM}
#	WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
#    LOGNAME setVSvars-${TARGET_TRIPLET}
#)

set(DEPENDENCIES FREETYPE=1)

vcpkg_execute_required_process(
	COMMAND ${SOURCE_PATH}/win32/make-uwp.bat debug ${INCLUDE_DIR} ${LIB_DIR_DBG} ${MKENUMS_TOOL_DIR} ${PERL_INTERPRETER} ${NATIVE_PACKAGES_DIR_DBG} ${UWP_PLATFORM}
	WORKING_DIRECTORY ${SOURCE_PATH}/win32/
	LOGNAME nmake-build-${TARGET_TRIPLET}-debug
)

vcpkg_execute_required_process(
	COMMAND ${SOURCE_PATH}/win32/make-uwp.bat release ${INCLUDE_DIR} ${LIB_DIR_REL} ${MKENUMS_TOOL_DIR} ${PERL_INTERPRETER} ${NATIVE_PACKAGES_DIR_REL} ${UWP_PLATFORM}
	WORKING_DIRECTORY ${SOURCE_PATH}/win32/
	LOGNAME nmake-build-${TARGET_TRIPLET}-release
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/harfbuzz/COPYING ${CURRENT_PACKAGES_DIR}/share/harfbuzz/copyright)
