if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(VCPKG_LIBRARY_LINKAGE dynamic)
    message("Static building not supported yet")
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

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/openssl-OpenSSL_1_0_2_WinRT-stable)

vcpkg_find_acquire_program(PERL)
vcpkg_find_acquire_program(JOM)
get_filename_component(JOM_EXE_PATH ${JOM} DIRECTORY)
get_filename_component(PERL_EXE_PATH ${PERL} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${PERL_EXE_PATH};${JOM_EXE_PATH}")

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/Microsoft/openssl/archive/OpenSSL_1_0_2_WinRT-stable.zip"
    FILENAME "OpenSSL_1_0_2_WinRT-stable.zip"
    SHA512 e0a4abfd8b1dc7c2e84621f87c5ff6a5a803edb3af1c90e671a0350853b92de4d190f46d539392326f640b10ec59e355e650e18ad2440fe4d9a0386d8239783d
)

vcpkg_extract_source_archive(${ARCHIVE})

file(REMOVE_RECURSE ${SOURCE_PATH}/tmp32dll)
file(REMOVE_RECURSE ${SOURCE_PATH}/out32dll)
file(REMOVE_RECURSE ${SOURCE_PATH}/inc32dll)

file(
    COPY ${CMAKE_CURRENT_LIST_DIR}/make-openssl.bat
    DESTINATION ${SOURCE_PATH}
)

message(STATUS "Build ${TARGET_TRIPLET}")
vcpkg_execute_required_process(
    COMMAND ${SOURCE_PATH}/make-openssl.bat ${UWP_PLATFORM}
    WORKING_DIRECTORY ${SOURCE_PATH}
    LOGNAME make-openssl-${TARGET_TRIPLET}
)
message(STATUS "Build ${TARGET_TRIPLET} done")

file(
    COPY ${SOURCE_PATH}/inc32/openssl
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
)

file(INSTALL
    ${SOURCE_PATH}/vsout/NT-Universal-10.0-Static-Unicode/Release/${UWP_PLATFORM}/bin/libeay32.lib
	${SOURCE_PATH}/vsout/NT-Universal-10.0-Static-Unicode/Release/${UWP_PLATFORM}/bin/ssleay32.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

file(INSTALL
	${SOURCE_PATH}/vsout/NT-Universal-10.0-Static-Unicode/Debug/${UWP_PLATFORM}/bin/libeay32.lib
	${SOURCE_PATH}/vsout/NT-Universal-10.0-Static-Unicode/Debug/${UWP_PLATFORM}/bin/ssleay32.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)


file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})

vcpkg_test_cmake(PACKAGE_NAME OpenSSL MODULE)
