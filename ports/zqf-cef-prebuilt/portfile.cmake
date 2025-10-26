set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_download_distfile(
  ARCHIVE
  URLS "https://cef-builds.spotifycdn.com/cef_binary_141.0.11%2Bg7e73ac4%2Bchromium-141.0.7390.123_windows64.tar.bz2"
  FILENAME "cef_prebuilt.tar.bz2"
  SHA512 f6e6a658b8dc41b0be3f0c5f9287cab408a9e54bdf141b8497391cf0154f070ff49776b6e11e7aa4a5774930c50380008615c5f30f2a8a5a8bceca94cc367b80
)

vcpkg_extract_source_archive(
  CEF_PREBUILT_FILES
  ARCHIVE "${ARCHIVE}"
)

vcpkg_cmake_configure(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/src/" OPTIONS -DCEF_ROOT=${CEF_PREBUILT_FILES})
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME zqf_cef_prebuilt CONFIG_PATH share/cmake/zqf_cef_prebuilt)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
