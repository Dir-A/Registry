include_guard(GLOBAL)

function(zqf_optimizer_enable_lto)
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    return()
  endif()

  if(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS AND MSVC)
    message(WARNING "### CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS is not compatible with CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ###")
  endif()

  cmake_policy(SET CMP0069 NEW)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT ipo_check_result OUTPUT output)

  if(ipo_check_result)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE PARENT_SCOPE)
  else()
    message(WARNING "LTCG is not supported: ${output}")
  endif()
endfunction()

function(zqf_optimizer_enable_gc_sections)
  if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
    return()
  endif()

  add_link_options($<$<OR:$<C_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>:-Wl,--gc-sections>)
  add_compile_options($<$<OR:$<C_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>:-ffunction-sections>)
  add_compile_options($<$<OR:$<C_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:GNU>,$<C_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:Clang>>:-fdata-sections>)
endfunction()
