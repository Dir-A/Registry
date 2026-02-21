cmake_minimum_required(VERSION 3.31)

if(NOT DEFINED PHNT_ROOT)
  set(PHNT_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.assets/phnt/")
endif()

if(NOT EXISTS ${PHNT_ROOT})
  message(FATAL_ERROR "not fond phnt files")
endif()

project("zqf_phnt" VERSION 1.0 LANGUAGES C CXX)

install(
  DIRECTORY "${PHNT_ROOT}/"
  DESTINATION "include/phnt/"
  COMPONENT headers
  FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
)

install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/phnt-config.cmake
  DESTINATION "share/cmake/phnt/"
)
