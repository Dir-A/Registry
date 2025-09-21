set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

vcpkg_from_git(
  OUT_SOURCE_PATH SOURCE_PATH
  URL https://github.com/ZQF-Zut/ZxJson.git
  REF 372eb3c80affbaa9d75f42c32a0ae8296bcaa6e0
  HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME zqf_zut_zxjson CONFIG_PATH share/cmake/zqf_zut_zxjson)
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
