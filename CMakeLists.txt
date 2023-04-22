cmake_minimum_required(VERSION 3.26)
set(LUA_VERSION 5.4.4)
project(Lua
  VERSION ${LUA_VERSION}
  DESCRIPTION "Lua and LuaRocks packaged by DEVCOM"
  HOMEPAGE_URL https://github.com/DevelopersCommunity/cmake-lua
  LANGUAGES C
  )

set(LUA_TARBALL lua-${CMAKE_PROJECT_VERSION}.tar.gz)
set(LUA_TARBALL_SHA1 03c27684b9d5d9783fb79a7c836ba1cdc5f309cd)

if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/${LUA_TARBALL})
  file(DOWNLOAD https://www.lua.org/ftp/${LUA_TARBALL}
    ${CMAKE_CURRENT_LIST_DIR}/${LUA_TARBALL}
    EXPECTED_HASH SHA1=${LUA_TARBALL_SHA1}
    )
  file(ARCHIVE_EXTRACT INPUT ${CMAKE_CURRENT_LIST_DIR}/${LUA_TARBALL}
    DESTINATION ${CMAKE_CURRENT_LIST_DIR}
    )
endif()

if(WIN32)
  set(LUAROCKS_VERSION 3.9.2)
  set(LUAROCKS_TARBALL luarocks-${LUAROCKS_VERSION}-windows-64.zip)

  if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/${LUAROCKS_TARBALL})
    file(DOWNLOAD http://luarocks.github.io/luarocks/releases/${LUAROCKS_TARBALL}
      ${CMAKE_CURRENT_LIST_DIR}/${LUAROCKS_TARBALL}
      )
    file(ARCHIVE_EXTRACT INPUT ${CMAKE_CURRENT_LIST_DIR}/${LUAROCKS_TARBALL}
      DESTINATION ${CMAKE_CURRENT_LIST_DIR}
      )
  endif()

  set(LUA_LOGO lua-logo-nolabel.ps)
  if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/${LUA_LOGO})
    file(DOWNLOAD https://www.lua.org/images/${LUA_LOGO}
      ${CMAKE_CURRENT_LIST_DIR}/${LUA_LOGO}
      )
  endif()

  add_custom_command(OUTPUT lua.ico
    COMMAND magick ${CMAKE_CURRENT_LIST_DIR}/${LUA_LOGO} -resize 256x256 lua.ico
    MAIN_DEPENDENCY ${CMAKE_CURRENT_LIST_DIR}/${LUA_LOGO}
    COMMENT "Generating Lua icon"
    )
  add_custom_target(luaicon ALL DEPENDS lua.ico)
endif()

set(LUA_SRC lua-${CMAKE_PROJECT_VERSION}/src)
set(LUA_DOC lua-${CMAKE_PROJECT_VERSION}/doc)

set(LIB
  ${LUA_SRC}/lapi.c
  ${LUA_SRC}/lcode.c
  ${LUA_SRC}/lctype.c
  ${LUA_SRC}/ldebug.c
  ${LUA_SRC}/ldo.c
  ${LUA_SRC}/ldump.c
  ${LUA_SRC}/lfunc.c
  ${LUA_SRC}/lgc.c
  ${LUA_SRC}/llex.c
  ${LUA_SRC}/lmem.c
  ${LUA_SRC}/lobject.c
  ${LUA_SRC}/lopcodes.c
  ${LUA_SRC}/lparser.c
  ${LUA_SRC}/lstate.c
  ${LUA_SRC}/lstring.c
  ${LUA_SRC}/ltable.c
  ${LUA_SRC}/ltm.c
  ${LUA_SRC}/lundump.c
  ${LUA_SRC}/lvm.c
  ${LUA_SRC}/lzio.c
  ${LUA_SRC}/lauxlib.c
  ${LUA_SRC}/lbaselib.c
  ${LUA_SRC}/lcorolib.c
  ${LUA_SRC}/ldblib.c
  ${LUA_SRC}/liolib.c
  ${LUA_SRC}/lmathlib.c
  ${LUA_SRC}/loadlib.c
  ${LUA_SRC}/loslib.c
  ${LUA_SRC}/lstrlib.c
  ${LUA_SRC}/ltablib.c
  ${LUA_SRC}/lutf8lib.c
  ${LUA_SRC}/linit.c
)

set(LUA
  ${LUA_SRC}/lua.c
  )

set (LUAC
  ${LUA_SRC}/luac.c
  )

include(CheckLibraryExists)
check_library_exists(m pow "" LIBEXISTS)
if(LIBEXISTS)
  set(LIBM "m")
endif()

add_executable(lua ${LUA} ${LIB})
target_link_libraries(lua PUBLIC ${LIBM})

add_executable(luac ${LUAC} ${LIB})
target_link_libraries(luac PUBLIC ${LIBM})

add_library(lualib SHARED ${LIB})
target_sources(lualib
  PUBLIC
  FILE_SET include TYPE HEADERS BASE_DIRS ${LUA_SRC}
  FILES ${LUA_SRC}/lauxlib.h  ${LUA_SRC}/lua.h  ${LUA_SRC}/lua.hpp  ${LUA_SRC}/luaconf.h  ${LUA_SRC}/lualib.h
  )

if(WIN32)
  target_compile_definitions(lualib PUBLIC LUA_BUILD_AS_DLL)
  set_property(TARGET lualib PROPERTY OUTPUT_NAME lua${CMAKE_PROJECT_VERSION_MAJOR}${CMAKE_PROJECT_VERSION_MINOR})

  install(PROGRAMS
    ${CMAKE_CURRENT_LIST_DIR}/luarocks-${LUAROCKS_VERSION}-windows-64/luarocks.exe
    ${CMAKE_CURRENT_LIST_DIR}/luarocks-${LUAROCKS_VERSION}-windows-64/luarocks-admin.exe
    TYPE BIN)
else()
  set_property(TARGET lualib PROPERTY OUTPUT_NAME lua)
endif()

install(TARGETS lua luac)
install(TARGETS lualib FILE_SET include)

if(WIN32)
  set(CPACK_GENERATOR ZIP WIX)
  set(CPACK_WIX_UPGRADE_GUID "3e5a792d-9d31-41d5-a93f-629ab7c7683d")
  set(CPACK_WIX_PRODUCT_ICON lua.ico)
  list(APPEND CPACK_WIX_EXTENSIONS WixUtilExtension)
  list(APPEND CPACK_WIX_PATCH_FILE ${CMAKE_CURRENT_LIST_DIR}/WixPatch.xml)
else()
  install(FILES ${LUA_DOC}/lua.1 ${LUA_DOC}/luac.1
    DESTINATION man/man1
    )
endif()
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_LIST_DIR}/LICENSE.txt")
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CMAKE_PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR DEVCOM)
include(CPack)
