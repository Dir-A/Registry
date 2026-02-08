# ZxPKG Test
cmake_minimum_required(VERSION 3.31)

# VCPKG
if(ZQF_VCPKG)
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/vcpkg_fetch.cmake")
    file(DOWNLOAD https://raw.githubusercontent.com/Dir-A/Registry/a30058c632ccf7530627f39eff624d495444d676/cmake/vcpkg_fetch.cmake "${CMAKE_BINARY_DIR}/vcpkg_fetch.cmake")
  endif()

  include("${CMAKE_BINARY_DIR}/vcpkg_fetch.cmake")
endif()

# Project Name
project("zxpkg_test" VERSION 1.0 LANGUAGES C CXX)

# Set Executable
add_executable(${PROJECT_NAME} "main.cpp")
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)

# External Packages
find_package(zqf_zut_zxjson CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE ZQF::Zut::ZxJson)
find_package(fmt CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt)

