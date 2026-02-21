get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)

if(NOT TARGET phnt::phnt)
  add_library(phnt INTERFACE)
  add_library(phnt::phnt ALIAS phnt)
  target_include_directories(phnt SYSTEM INTERFACE ${PACKAGE_PREFIX_DIR}/include/phnt/)
  target_link_libraries(phnt INTERFACE $<$<PLATFORM_ID:Windows>:ntdll.lib>)
endif()
