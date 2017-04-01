cmake_minimum_required(VERSION 2.8)
project(nfd-unity3d)

set(CMAKE_C_FLAGS_RELEASE "-DNDEBUG ${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_DEBUG "-DDEBUG ${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_DEBUG_POSTFIX "_d")

file(GLOB NFD_SRC
  "nativefiledialog/src/*.h"
  "nativefiledialog/src/include/*.h"
  "nativefiledialog/src/nfd_common.c"
  )

include_directories("nativefiledialog/src/include") 
if(APPLE)
  set(NFD_SRC nativefiledialog/src/nfd_cocoa.m ${NFD_SRC})
  set(CMAKE_C_FLAGS "-arch i386 -arch x86_64 -fno-exceptions ${CMAKE_C_FLAGS}")
  find_library(APPKIT_LIBRARY AppKit)
  mark_as_advanced(APPKIT_LIBRARY)
  link_libraries(${APPKIT_LIBRARY})
elseif(UNIX)
  set(NFD_SRC nativefiledialog/src/nfd_gtk.c ${NFD_SRC})
  set(CMAKE_C_FLAGS "-fno-exceptions ${CMAKE_C_FLAGS}")
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(GTK3 REQUIRED gtk+-3.0)
  include_directories(${GTK3_INCLUDE_DIRS})
  link_directories(${GTK3_LIBRARY_DIRS})
  add_definitions(${GTK3_CFLAGS_OTHER})
  link_libraries(${GTK3_LIBRARIES})
elseif(WIN32)
  add_definitions(-DNFD_BUILD_AS_DLL)
  set(NFD_SRC nativefiledialog/src/nfd_win.cpp ${NFD_SRC})
endif(APPLE)

if(MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif(MSVC)

add_library(nfd MODULE ${NFD_SRC})
set_target_properties(nfd PROPERTIES BUNDLE TRUE)
