cmake_minimum_required(VERSION 3.0)
project(libmicrohttpd)

if(CMAKE_BUILD_TYPE STREQUAL Debug)
    set(LIB_SUFFIX d)
endif()

add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS)
add_definitions(-D_WIN32 -DMHD_W32DLL -D_USRDLL -DBUILDING_MHD_LIB)

if(CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    add_definitions(-D_WIN32_WINNT=0x0A00)
endif()

if(CMAKE_BUILD_TYPE MATCHES "Debug")
    #kodi debug builds need this
    add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)
endif()

add_library(libmicrohttpd
    src/microhttpd/base64.c
    src/microhttpd/basicauth.c
    src/microhttpd/connection.c
    src/microhttpd/connection.c
    src/microhttpd/daemon.c
    src/microhttpd/digestauth.c
    src/microhttpd/internal.c
    src/microhttpd/md5.c
    src/microhttpd/memorypool.c
    src/microhttpd/mhd_mono_clock.c
    src/microhttpd/mhd_str.c
    src/microhttpd/postprocessor.c
    src/microhttpd/reason_phrase.c
    src/microhttpd/response.c
    src/microhttpd/sysfdsetsize.c
    src/microhttpd/tsearch.c
    src/platform/w32functions.c)

target_include_directories(libmicrohttpd PRIVATE . ./src/include ./src/microhttpd ./w32/common)

install(TARGETS libmicrohttpd
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

if(NOT FC_SKIP_HEADERS)
    install(FILES
        src/include/microhttpd.h
        DESTINATION include/libmicrohttpd)
endif()


