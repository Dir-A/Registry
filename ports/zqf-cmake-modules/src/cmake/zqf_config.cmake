include_guard(GLOBAL)

function(zqf_config_output_dir)
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

function(zqf_config_cxx_exception)
  set(options
    DisableGlobally
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_DisableGlobally)
    if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
      add_compile_definitions(_HAS_EXCEPTIONS=0)
      string(REPLACE "/EHsc" "" my_cmake_cxx_flags "${CMAKE_CXX_FLAGS}") # Disable C++ Exception
      set(CMAKE_CXX_FLAGS ${my_cmake_cxx_flags} PARENT_SCOPE)
    else()
      message(FATAL_ERROR "zqf_config_cxx_exception: unimp")
    endif()

  else()
    message(FATAL_ERROR "zqf_config_cxx_exception: unknown options")
  endif()
endfunction()

function(zqf_config_runtime_error_checks)
  if(NOT(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC"))
    message(FATAL_ERROR "zqf_config_runtime_error_checks: only for MSVC frontend compiler")
  endif()

  set(options
    DisableGlobally
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_DisableGlobally)
    if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
      string(REPLACE "/RTC1" "" my_cmake_cxx_flags_debug "${CMAKE_CXX_FLAGS_DEBUG}") # Disable Run-time error checks
      string(REPLACE "/RTC1" "" my_cmake_c_flags_debug "${CMAKE_C_FLAGS_DEBUG}") # Disable Run-time error checks

      set(CMAKE_CXX_FLAGS_DEBUG ${my_cmake_cxx_flags_debug} PARENT_SCOPE)
      set(CMAKE_C_FLAGS_DEBUG ${my_cmake_c_flags_debug} PARENT_SCOPE)
    else()
      message(FATAL_ERROR "zqf_config_runtime_error_checks: unimp")
    endif()
  else()
    message(FATAL_ERROR "zqf_config_runtime_error_checks: unknown options")
  endif()
endfunction()
