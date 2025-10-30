include_guard(GLOBAL)

macro(CEF_STARTUP)
  option(USE_ATL OFF)
  option(USE_SANDBOX OFF)

  set(generator_backup ${CMAKE_GENERATOR})
  set(CMAKE_GENERATOR "UNKNOWN")
  include("${CEF_ROOT}/cmake/FindCEF.cmake")
  set(CMAKE_GENERATOR ${generator_backup})

  list(REMOVE_ITEM CEF_CXX_COMPILER_FLAGS "-std=c++17")
  list(REMOVE_ITEM CEF_CXX_COMPILER_FLAGS "/std:c++17")
  list(REMOVE_ITEM CEF_CXX_COMPILER_FLAGS "-fno-exceptions")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS_RELEASE "/MT")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS_RELEASE "/O2")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS_RELEASE "/Ob2")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS_DEBUG "/MTd")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS_DEBUG "/RTC1")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS_DEBUG "/Od")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS "/Zi")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS "/GR-")
  list(REMOVE_ITEM CEF_COMPILER_FLAGS "/MP")
  list(REMOVE_ITEM CEF_COMPILER_DEFINES "_HAS_EXCEPTIONS=0")

  if(NOT TARGET ZQF::CEF::CEF)
    if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
      add_library(zqf_cef_cef INTERFACE)
      add_library(ZQF::CEF::CEF ALIAS zqf_cef_cef)
      target_link_libraries(zqf_cef_cef INTERFACE libcef_dll_wrapper ${CEF_STANDARD_LIBS})
    else()
      # Add CEF C Libary Target
      ADD_LOGICAL_TARGET("libcef_lib" "${CEF_LIB_DEBUG}" "${CEF_LIB_RELEASE}")

      # C Library
      add_library(zqf_cef_c_library INTERFACE)
      add_library(ZQF::CEF::CLibrary ALIAS zqf_cef_c_library)
      target_link_libraries(zqf_cef_c_library INTERFACE libcef_lib ${CEF_STANDARD_LIBS})

      # CXX Wrapper
      add_library(zqf_cef_cxx_wrapper INTERFACE)
      add_library(ZQF::CEF::CXXWrapper ALIAS zqf_cef_cxx_wrapper)
      target_link_libraries(zqf_cef_cxx_wrapper INTERFACE libcef_dll_wrapper)

      # Combine C Libary And CXX Wrapper
      add_library(zqf_cef_full INTERFACE)
      add_library(ZQF::CEF::CEF ALIAS zqf_cef_full)
      target_link_libraries(zqf_cef_full INTERFACE ZQF::CEF::CLibrary ZQF::CEF::CXXWrapper)
    endif()
  endif()
endmacro()

function(zqf_cef_config target)
  SET_EXECUTABLE_TARGET_PROPERTIES("${target}")
endfunction()

function(zqf_cef_copyfiles target)
  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(target_dir "$<TARGET_BUNDLE_DIR:${target}>/../")
    add_custom_command(
      POST_BUILD
      TARGET "${target}"
      COMMAND ${CMAKE_COMMAND} -E copy_directory
      "${CEF_BINARY_DIR}/Chromium Embedded Framework.framework"
      "${target_dir}/Chromium Embedded Framework.framework"
      VERBATIM
    )
  else()
    set(target_dir "$<TARGET_FILE_DIR:${target}>")
    COPY_FILES("${target}" "${CEF_BINARY_FILES}" "${CEF_BINARY_DIR}" "${target_dir}")
    COPY_FILES("${target}" "${CEF_RESOURCE_FILES}" "${CEF_RESOURCE_DIR}" "${target_dir}")

    if(EXISTS "${CEF_BINARY_DIR}/libminigbm.so")
      COPY_FILES("${target}" "libminigbm.so" "${CEF_BINARY_DIR}" "${target_dir}")
    endif()
  endif()
endfunction()
