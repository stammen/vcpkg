cmake_minimum_required(VERSION 3.0)
project(crossguid)

add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS)

if(CMAKE_BUILD_TYPE STREQUAL Debug)
    set(LIB_SUFFIX d)
endif()

add_definitions(-DWIN32)
add_definitions(-DGUID_WINDOWS)
if(CMAKE_BUILD_TYPE MATCHES "Debug")
    add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)
endif()

add_library(crossguid guid.cpp)

target_include_directories(crossguid PRIVATE .)

install(TARGETS crossguid
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

if(NOT FC_SKIP_HEADERS)
    install(FILES
        guid.h
        DESTINATION include/crossguid)
endif()


