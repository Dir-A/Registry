set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

if(VCPKG_TARGET_IS_WINDOWS)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(cef_prebuilt_type "windows32")
    set(cef_prebuilt_sha512 "50530ff20168b831b9136bd5d2aaa8f50ea08ab688aa87b812992eda236780869005f567e0af7bdcf4e76dd8470a68efd7bdb90e1b8b0e4565154e89f2c3675e")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(cef_prebuilt_type "windows64")
    set(cef_prebuilt_sha512 "f6e6a658b8dc41b0be3f0c5f9287cab408a9e54bdf141b8497391cf0154f070ff49776b6e11e7aa4a5774930c50380008615c5f30f2a8a5a8bceca94cc367b80")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(cef_prebuilt_type "windowsarm64")
    set(cef_prebuilt_sha512 "19d5d706459e5102e220d062478da880947201b64846bba7ae31c8f7d81865c3725063187c2bb2d7723ec31eaa27bd2faf71d6c347dd96d49a006488a5ca33fd")
  endif()
elseif(VCPKG_TARGET_IS_LINUX)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(cef_prebuilt_type "linux64")
    set(cef_prebuilt_sha512 "aac1dc3c1887fc11e0a5735f1836e8e4a36842d1c2d457e5f6030174e723205f3dbc34876b53173c26f041b3392d47e93d9c33d4219841c18777242d0edb0529")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    set(cef_prebuilt_type "linuxarm")
    set(cef_prebuilt_sha512 "ed47b3bae58d00bd86b188c1f88a28320d6b7248abed1a2ebf9e9679a40bb96bbc26987601a97766ccfd1ed414e4c464f93d2760c001cde8756d4bb30925a423")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(cef_prebuilt_type "linuxarm64")
    set(cef_prebuilt_sha512 "bc4f4eb6ac2780a147105712805a5bc0bd14a3f4789a3327c7f3d5c5aa9f89127906b497a1c664e26d7e55a3aa414cc586040cc04d236e34fd5fb049dd449136")
  endif()
elseif(VCPKG_TARGET_IS_OSX)
  if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(cef_prebuilt_type "macosx64")
    set(cef_prebuilt_sha512 "3d58ae46864b2970eba2d21b63c37b540563fe36e12d89c9a156d080dda84ec60a8073fcec345fa450ee50b9f52631b8870499d8464a6e280f69d04a2abb9877")
  elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(cef_prebuilt_type "macosarm64")
    set(cef_prebuilt_sha512 "ea5e2f22e58fb2f742dfa9390921ff5b42dcf9e7b920b20e1827ca242cb77d994a390795a248761824f3f4f8d3698694eee8f4bb861581dfaf10907ae025d7b4")
  endif()
endif()

if(NOT DEFINED cef_prebuilt_type)
  message(FATAL_ERROR "not supported cef prebuilt type")
endif()

set(cef_prebuilt_filename "cef_binary_${VERSION}+g7e73ac4+chromium-141.0.7390.123_${cef_prebuilt_type}.tar.bz2")

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
