include_guard(GLOBAL)

function(zqf_set_output_dir)
  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}-32/" PARENT_SCOPE)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}-32/" PARENT_SCOPE)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}-32/lib/" PARENT_SCOPE)
  else()
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}-64/" PARENT_SCOPE)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}-64/" PARENT_SCOPE)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}-64/lib/" PARENT_SCOPE)
  endif()
endfunction()

function(zqf_set_warning TARGET_NAME)
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
    message(FATAL_ERROR "zqf_set_warning: unknown warning level")
  endif()
endfunction()

function(zqf_set_encoding)
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
    message(FATAL_ERROR "zqf_set_encoding: unknown encoding")
  endif()

  target_compile_options(${PROJECT_NAME} ${SCOPE}
    $<$<OR:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>:${flags}> # msvc
    $<$<OR:$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>:$<$<OR:$<C_COMPILER_FRONTEND_VARIANT:MSVC>,$<CXX_COMPILER_FRONTEND_VARIANT:MSVC>>:${flags}> # msvc frontend
    >
  )
endfunction()
