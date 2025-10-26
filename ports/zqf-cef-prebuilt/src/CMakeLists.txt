cmake_minimum_required(VERSION 3.31)

if(NOT DEFINED CEF_ROOT)
  set(CEF_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.assets/cef_prebuilt/")
endif()

if(NOT EXISTS ${CEF_ROOT})
  message(FATAL_ERROR "not fond cef prebuilt files")
endif()

project("zqf_cef_prebuilt" VERSION 1.0 LANGUAGES C CXX)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/cef_patch.cmake")
CEF_STARTUP()

add_subdirectory(${CEF_LIBCEF_DLL_WRAPPER_PATH} libcef_dll_wrapper)
target_compile_features(libcef_dll_wrapper PRIVATE cxx_std_17)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/cef_installer.cmake")
cef_installer(
  ${PROJECT_NAME}
  VERSION ${PROJECT_VERSION}
  CEF_PREBUILT_DIR ${CEF_ROOT}
  CONFIG_TEMPLATE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Config.cmake.in"
)
