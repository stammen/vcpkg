cmake_minimum_required(VERSION 3.0)
project(libfribidi)

add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS)

if(CMAKE_BUILD_TYPE STREQUAL Debug)
    set(LIB_SUFFIX d)
endif()

add_definitions(-DWIN32)
add_definitions(-DTIXML_USE_STL)
if(CMAKE_BUILD_TYPE MATCHES "Debug")
    add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)
endif()

add_library(libfribidi
    lib/fribidi.c
    lib/fribidi-arabic.c
    lib/fribidi-bidi.c
    lib/fribidi-bidi-types.c
    lib/fribidi-deprecated.c
    lib/fribidi-joining.c
    lib/fribidi-joining-types.c
    lib/fribidi-mem.c
    lib/fribidi-mirroring.c
    lib/fribidi-run.c
    lib/fribidi-shape.c)

target_include_directories(libfribidi PRIVATE .)

install(TARGETS libfribidi
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

if(NOT FC_SKIP_HEADERS)
    install(FILES
        lib/fribidi.h
        lib/fribidi-arabic.h
        lib/fribidi-begindecls.h
        lib/fribidi-bidi.h
        lib/fribidi-bidi-types.h
        lib/fribidi-bidi-types-list.h
        lib/fribidi-char-sets.h
        lib/fribidi-char-sets-list.h
        lib/fribidi-common.h
        lib/fribidi-config.h
        lib/fribidi-deprecated.h
        lib/fribidi-enddecls.h
        lib/fribidi-flags.h
        lib/fribidi-joining.h
        lib/fribidi-joining-types.h
        lib/fribidi-joining-types-list.h
        lib/fribidi-mirroring.h
        lib/fribidi-shape.h
        lib/fribidi-types.h
        lib/fribidi-unicode.h
        lib/fribidi-unicode-version.h
        DESTINATION include/libfribidi)
endif()


