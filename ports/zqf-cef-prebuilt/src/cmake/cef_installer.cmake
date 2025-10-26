include_guard(GLOBAL)

function(cef_installer TARGET_NAME)
  # ArgParse
  set(options)
  set(multiValueArgs)
  set(oneValueArgs VERSION CEF_PREBUILT_DIR CONFIG_TEMPLATE_PATH)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}")

  include(GNUInstallDirs)
  include(CMakePackageConfigHelpers)

  # Export
  set(export_name ${TARGET_NAME}-target)
  set(export_dir "share/cmake/${TARGET_NAME}/")
  install(
    EXPORT ${export_name}
    FILE "${TARGET_NAME}-targets.cmake"
    DESTINATION ${export_dir}
  )

  # Target
  install(
    TARGETS libcef_dll_wrapper
    EXPORT ${export_name}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  )

  # Resources
  install(
    DIRECTORY
    "${ZQF_CEF_PREBUILT_DIR}/Debug/"
    DESTINATION ${export_dir}/cef_root/Debug/
    USE_SOURCE_PERMISSIONS
  )
  install(
    DIRECTORY
    "${ZQF_CEF_PREBUILT_DIR}/Release/"
    DESTINATION ${export_dir}/cef_root/Release/
    USE_SOURCE_PERMISSIONS
  )
  install(
    DIRECTORY
    "${ZQF_CEF_PREBUILT_DIR}/Resources/"
    DESTINATION ${export_dir}/cef_root/Resources/
  )
  install(
    DIRECTORY
    "${ZQF_CEF_PREBUILT_DIR}/include/"
    DESTINATION ${export_dir}/cef_root/include/
  )
  install(
    DIRECTORY
    "${ZQF_CEF_PREBUILT_DIR}/cmake/"
    DESTINATION ${export_dir}/cef_root/cmake/
  )
  install(FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cef_patch.cmake"
    DESTINATION ${export_dir}/cmake/
  )

  # Config && Version
  set(config_file_path "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-config.cmake")
  set(version_file_path "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-config-version.cmake")
  configure_package_config_file(
    ${ZQF_CONFIG_TEMPLATE_PATH}
    ${config_file_path}
    INSTALL_DESTINATION ${export_dir}
  )
  write_basic_package_version_file(
    ${version_file_path}
    VERSION ${ZQF_VERSION}
    COMPATIBILITY SameMajorVersion
  )
  install(FILES
    ${config_file_path}
    ${version_file_path}
    DESTINATION ${export_dir}
  )
endfunction()
