include_guard(GLOBAL)

function(zqf_target_warning TARGET_NAME)
  set(options
    PRIVATE
    PUBLIC
    INTERFACE
    AllExtra
    All
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_PUBLIC)
    set(SCOPE PUBLIC)
  elseif(ZQF_INTERFACE)
    set(SCOPE INTERFACE)
  else()
    set(SCOPE PRIVATE)
  endif()

  if(ZQF_AllExtra)
    target_compile_options(${TARGET_NAME} ${SCOPE}
      $<$<OR:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>:/W4> # msvc
      $<$<OR:$<C_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:GNU>>:-Wall -Wextra> # gcc
      $<$<OR:$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>: # clang
      $<$<OR:$<C_COMPILER_FRONTEND_VARIANT:GNU>,$<CXX_COMPILER_FRONTEND_VARIANT:GNU>>:-Wall -Wextra> # gnu frontend
      $<$<OR:$<C_COMPILER_FRONTEND_VARIANT:MSVC>,$<CXX_COMPILER_FRONTEND_VARIANT:MSVC>>:/W4> # msvc frontend
      >
    )
  elseif(ZQF_All)
    target_compile_options(${TARGET_NAME} ${SCOPE}
      $<$<OR:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>:/W3> # msvc
      $<$<OR:$<C_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:GNU>>:-Wall> # gcc
      $<$<OR:$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>: # clang
      $<$<OR:$<C_COMPILER_FRONTEND_VARIANT:GNU>,$<CXX_COMPILER_FRONTEND_VARIANT:GNU>>:-Wall> # gnu frontend
      $<$<OR:$<C_COMPILER_FRONTEND_VARIANT:MSVC>,$<CXX_COMPILER_FRONTEND_VARIANT:MSVC>>:/W3> # msvc frontend
      >
    )
  else()
    message(FATAL_ERROR "zqf_target_warning: unknown warning level")
  endif()
endfunction()

function(zqf_target_encoding)
  set(options
    PRIVATE
    PUBLIC
    INTERFACE
    UTF8
    SOURCE_UTF8
    TARGET_UTF8
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_PUBLIC)
    set(SCOPE PUBLIC)
  elseif(ZQF_INTERFACE)
    set(SCOPE INTERFACE)
  else()
    set(SCOPE PRIVATE)
  endif()

  if(ZQF_UTF8 OR(ZQF_SOURCE_UTF8 AND ZQF_TARGET_UTF8))
    set(flags "/utf-8")
  elseif(ZQF_SOURCE_UTF8)
    set(flags "/source-charset:utf-8")
  elseif(ZQF_TARGET_UTF8)
    set(flags "/execution-charset:utf-8")
  else()
    message(FATAL_ERROR "zqf_target_encoding: unknown encoding")
  endif()

  target_compile_options(${PROJECT_NAME} ${SCOPE}
    $<$<OR:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>:${flags}> # msvc
    $<$<OR:$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>:$<$<OR:$<C_COMPILER_FRONTEND_VARIANT:MSVC>,$<CXX_COMPILER_FRONTEND_VARIANT:MSVC>>:${flags}> # msvc frontend
    >
  )
endfunction()

function(zqf_target_hide_deps_symbols TARGET_NAME)
  get_target_property(target_type ${TARGET_NAME} TYPE)

  if((NOT target_type STREQUAL "SHARED_LIBRARY") AND(NOT target_type STREQUAL "MODULE_LIBRARY"))
    message(FATAL_ERROR "zqf_target_hide_deps_symbols: can only be applied to SHARED libraries")
    return()
  endif()

  set(options
    PRIVATE
    PUBLIC
    INTERFACE
    All
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_PUBLIC)
    set(SCOPE PUBLIC)
  elseif(ZQF_INTERFACE)
    set(SCOPE INTERFACE)
  else()
    set(SCOPE PRIVATE)
  endif()

  if(ZQF_All)
    target_link_options(${TARGET_NAME} ${SCOPE}
      $<$<OR:$<C_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:GNU>>:-Wl,--exclude-libs,ALL> # gcc
      $<$<OR:$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>: # clang
      $<$<OR:$<C_COMPILER_FRONTEND_VARIANT:GNU>,$<CXX_COMPILER_FRONTEND_VARIANT:GNU>>:-Wl,--exclude-libs,ALL> # gnu frontend
      >
    )
    target_link_options(${TARGET_NAME} ${SCOPE}
      $<$<OR:$<C_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:GNU>>:-Wl,-Bsymbolic> # gcc
      $<$<OR:$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>: # clang
      $<$<OR:$<C_COMPILER_FRONTEND_VARIANT:GNU>,$<CXX_COMPILER_FRONTEND_VARIANT:GNU>>:-Wl,-Bsymbolic> # gnu frontend
      >
    )
  else()
    message(FATAL_ERROR "zqf_target_hide_deps_symbols: unknown level")
  endif()
endfunction()

function(zqf_target_manifest TARGET_NAME)
  get_target_property(target_type ${TARGET_NAME} TYPE)

  if(NOT(target_type MATCHES "EXECUTABLE|MODULE_LIBRARY"))
    message(FATAL_ERROR "zqf_target_manifest: can only be applied to EXECUTABLE|MODULE_LIBRARY target")
    return()
  endif()

  set(options
    PRIVATE
    PUBLIC
    INTERFACE
    OFF
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_PUBLIC)
    set(SCOPE PUBLIC)
  elseif(ZQF_INTERFACE)
    set(SCOPE INTERFACE)
  else()
    set(SCOPE PRIVATE)
  endif()

  if(ZQF_OFF)
    if(CMAKE_LINKER MATCHES "link.exe")
      target_link_options(${TARGET_NAME} ${SCOPE}
        /MANIFEST:NO
      )
    else()
      message(FATAL_ERROR "zqf_target_manifest: unimp")
    endif()
  endif()
endfunction()

function(zqf_target_entrypoint TARGET_NAME)
  get_target_property(target_type ${TARGET_NAME} TYPE)

  if(NOT(target_type MATCHES "EXECUTABLE|MODULE_LIBRARY"))
    message(FATAL_ERROR "zqf_target_entrypoint: can only be applied to EXECUTABLE|MODULE_LIBRARY target")
    return()
  endif()

  set(options
    PRIVATE
    PUBLIC
    INTERFACE
    HideConsoleWindow
  )
  set(multiValueArgs)
  set(oneValueArgs
    CustomEntry
  )
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_PUBLIC)
    set(SCOPE PUBLIC)
  elseif(ZQF_INTERFACE)
    set(SCOPE INTERFACE)
  else()
    set(SCOPE PRIVATE)
  endif()

  if(ZQF_HideConsoleWindow)
    if(CMAKE_LINKER MATCHES "link.exe")
      target_link_options(${TARGET_NAME} ${SCOPE}
        /SUBSYSTEM:WINDOWS
        /ENTRY:mainCRTStartup
      )
    endif()
  elseif(ZQF_CustomEntry)
    if(CMAKE_LINKER MATCHES "link.exe")
      target_link_options(${TARGET_NAME} ${SCOPE}
        /ENTRY:${ZQF_CustomEntry}
      )
    endif()
  else()
    message(FATAL_ERROR "zqf_target_entrypoint: unknown option")
  endif()
endfunction()

function(zqf_target_default_lib TARGET_NAME)
  get_target_property(target_type ${TARGET_NAME} TYPE)

  if(NOT(target_type MATCHES "EXECUTABLE|MODULE_LIBRARY"))
    message(FATAL_ERROR "zqf_target_default_lib: can only be applied to EXECUTABLE|MODULE_LIBRARY target")
    return()
  endif()

  set(options
    PRIVATE
    PUBLIC
    INTERFACE
    OFF
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_PUBLIC)
    set(SCOPE PUBLIC)
  elseif(ZQF_INTERFACE)
    set(SCOPE INTERFACE)
  else()
    set(SCOPE PRIVATE)
  endif()

  if(ZQF_OFF)
    if(CMAKE_LINKER MATCHES "link.exe")
      target_link_options(${TARGET_NAME} ${SCOPE}
        /NODEFAULTLIB
      )
    endif()
  else()
    message(FATAL_ERROR "zqf_target_default_lib: unknown option")
  endif()
endfunction()

function(zqf_target_nocrt_flags TARGET_NAME)
  set(options
    PRIVATE
    PUBLIC
    INTERFACE
    All
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_PUBLIC)
    set(SCOPE PUBLIC)
  elseif(ZQF_INTERFACE)
    set(SCOPE INTERFACE)
  else()
    set(SCOPE PRIVATE)
  endif()

  if(ZQF_All)
    target_compile_options(${TARGET_NAME} ${SCOPE}
      $<$<OR:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>:
      /Oi- # Disable Generate Intrinsic Functions
      /sdl- # Disable Additional Security Checks
      /GS- # Disable Buffer Security Check
      /GR- # Disable Run-Time Type Information
      /Zc:inline # Remove unreferenced COMDAT
      /Gy # Enable Function-Level Linking
      > # msvc
      $<$<OR:$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>: # clang
      $<$<OR:$<C_COMPILER_FRONTEND_VARIANT:MSVC>,$<CXX_COMPILER_FRONTEND_VARIANT:MSVC>>:
      /Oi- # Disable Generate Intrinsic Functions
      /sdl- # Disable Additional Security Checks
      /GS- # Disable Buffer Security Check
      /GR- # Disable Run-Time Type Information
      /Zc:inline # Remove unreferenced COMDAT
      /Gy # Enable Function-Level Linking
      > # msvc frontend
      >
    )
  else()
    message(FATAL_ERROR "zqf_target_nocrt_flags: unknown option")
  endif()
endfunction()
