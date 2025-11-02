include_guard(GLOBAL)

function(zqf_installer TARGET_NAME)
  # ArgParse
  set(options)
  set(multiValueArgs)
  set(oneValueArgs
    VERSION
    NAMESPACE
    HEADER_FILE_DIR
    CONFIG_TEMPLATE_PATH
  )
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(NOT ZQF_CONFIG_TEMPLATE_PATH)
    message(FATAL_ERROR "zqf_installer: CONFIG_TEMPLATE_PATH is required")
  endif()

  if(NOT ZQF_VERSION)
    set(ZQF_VERSION ${PROJECT_VERSION})
  endif()

  include(GNUInstallDirs)
  include(CMakePackageConfigHelpers)

  set(header_file_dir ${ZQF_HEADER_FILE_DIR})
  set(export_target_name ${TARGET_NAME}-target)
  set(export_target_file_name ${TARGET_NAME}-targets.cmake)
  set(export_target_destination "share/cmake/${TARGET_NAME}")
  set(export_target_namespace ${ZQF_NAMESPACE}::)
  set(export_config_template ${ZQF_CONFIG_TEMPLATE_PATH})
  set(export_config_path ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-config.cmake)
  set(export_version_path ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-config-version.cmake)

  # Libraries
  install(
    TARGETS ${TARGET_NAME}
    EXPORT ${export_target_name}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )

  # Header Files
  if(header_file_dir)
    install(
      DIRECTORY ${header_file_dir}/
      DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
      COMPONENT headers
      FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
    )
  endif()

  # Export Target
  if(export_target_namespace)
    install(
      EXPORT ${export_target_name}
      FILE ${export_target_file_name}
      DESTINATION ${export_target_destination}
      NAMESPACE ${export_target_namespace}
    )
  else()
    install(
      EXPORT ${export_target_name}
      FILE ${export_target_file_name}
      DESTINATION ${export_target_destination}
    )
  endif()

  # Config Target
  configure_package_config_file(
    ${export_config_template}
    ${export_config_path}
    INSTALL_DESTINATION ${export_target_destination}
  )
  write_basic_package_version_file(
    ${export_version_path}
    VERSION ${ZQF_VERSION}
    COMPATIBILITY SameMajorVersion
  )
  install(FILES
    ${export_config_path}
    ${export_version_path}
    DESTINATION ${export_target_destination}
  )
endfunction()
