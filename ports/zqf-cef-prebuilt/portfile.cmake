set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
set(VCPKG_FIXUP_MACHO_RPATH OFF)

if(VCPKG_TARGET_IS_WINDOWS)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(cef_prebuilt_type "windows32")
    set(cef_prebuilt_sha512 "f26450cb749f063baa29a90d954d9fb6f652899cae6f72cd9d8cd8aa7896b792f5d48b8a8d1fe7e2fba69e0941e5f658d203c4076aa1ada5c4ebac890cdcce2b")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(cef_prebuilt_type "windows64")
    set(cef_prebuilt_sha512 "801338980b6699218f23174e541d7473ae8849f637058bfe16606dcb4e2c3fe581e03249a04ec866d99887e18e1dde3ad938276f9e72848219ed152632eba351")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(cef_prebuilt_type "windowsarm64")
    set(cef_prebuilt_sha512 "8237dcceb24c0d236b4063060e3384262bc3c710072a7edcb5a27c9f5b9540a41335711fed151c005125240749437d3ea9d0cf8467f548794bcc8588fba52662")
  endif()
elseif(VCPKG_TARGET_IS_LINUX)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(cef_prebuilt_type "linux64")
    set(cef_prebuilt_sha512 "047619c9e5535078a4a0cc686f4db9f92bd3df0365220a4a5dd889a40d170dc6509f5cdaff2c7645ee3550d100ef95aed288a60e7671206fc9ae266f16dd9bbc")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    set(cef_prebuilt_type "linuxarm")
    set(cef_prebuilt_sha512 "28ffa2548f4b7a226fe3db2243dd04e244169aac73b1bfe6e84c852781fff818009a7ce1a2ed4ad379d9311f7e0c500a555fc7ec5c911eb70334ac9e90fe7a97")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(cef_prebuilt_type "linuxarm64")
    set(cef_prebuilt_sha512 "c946984406b52d64efe6453a218b2268eb9d74b33b7b1f285f161b334030f7f12411a61cf2d192f464c19b2c6178a4ae11df999382f6bb161d5199ad144b5e83")
  endif()
elseif(VCPKG_TARGET_IS_OSX)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(cef_prebuilt_type "macosx64")
    set(cef_prebuilt_sha512 "f2878298b00b5dee64827416a82e7fdf7e5bb9afaf6d61d7d21ce63842de28553e05abfefa595472d75cb40a37e0641ce6763b7172bdb0422ca699a0e42b7031")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(cef_prebuilt_type "macosarm64")
    set(cef_prebuilt_sha512 "d75e9021933fc2c671e49c4f4a41386e2339a4e62fd2f4e2483bb5e7804937d20649181d9e1f517b0fc0ddf2334956ade6d94c78d2292434cb7cff1c61e4ccbd")
  endif()
endif()

if(NOT DEFINED cef_prebuilt_type)
  message(FATAL_ERROR "not supported cef prebuilt type")
endif()

set(cef_prebuilt_filename "cef_binary_148.0.10+g7ee53f5+chromium-${VERSION}_${cef_prebuilt_type}.tar.bz2")

vcpkg_download_distfile(
  cef_prebuilt_archive
  URLS "https://cef-builds.spotifycdn.com/${cef_prebuilt_filename}"
  FILENAME ${cef_prebuilt_filename}
  SHA512 ${cef_prebuilt_sha512}
)

vcpkg_extract_source_archive(
  cef_prebuilt_files
  ARCHIVE "${cef_prebuilt_archive}"
)

vcpkg_cmake_configure(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/src/" OPTIONS -DCEF_ROOT=${cef_prebuilt_files})
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME zqf_cef_prebuilt CONFIG_PATH share/cmake/zqf_cef_prebuilt)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
