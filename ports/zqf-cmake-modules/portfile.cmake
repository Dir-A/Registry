set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)
set(VCPKG_POLICY_ALLOW_EMPTY_FOLDERS enabled)
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Dir-A/CMakeModules
    REF 8741cc048049608d1d92d9a9febd3372c2ac5ebd
    SHA512 5519e8f14f09cdf858ee662938e8aa9f1cfb8d6dd06546bb742ab736741ffbea8557518a08d2ea5547b7843ad20eeaf11c156bf13b2b0222ff84474c99f2dd86
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME zqf_cmake_modules CONFIG_PATH share/cmake/zqf_cmake_modules)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")