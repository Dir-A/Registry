include_guard(GLOBAL)

function(zqf_vcpkg_fetch)
  set(zqf_vcpkg_root_dir "${CMAKE_SOURCE_DIR}/.vcpkg")

  if(EXISTS "${zqf_vcpkg_root_dir}/vcpkg")
    set(zqf_vcpkg_root_dir "${zqf_vcpkg_root_dir}" PARENT_SCOPE)
    return()
  endif()

  set(zqf_vcpkg_tool_release_url "https://github.com/microsoft/vcpkg-tool/releases/download/2025-12-05")

  if(WIN32)
    file(WRITE "${zqf_vcpkg_root_dir}/.vcpkg-root")
    file(DOWNLOAD "${zqf_vcpkg_tool_release_url}/vcpkg-init.cmd" "${zqf_vcpkg_root_dir}/vcpkg-init.cmd")
    execute_process(COMMAND cmd.exe /c "${zqf_vcpkg_root_dir}/vcpkg-init.cmd")
  else()
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
      file(DOWNLOAD "${zqf_vcpkg_tool_release_url}/vcpkg-glibc-arm64" "${zqf_vcpkg_root_dir}/vcpkg")
      execute_process(COMMAND chmod +x "${zqf_vcpkg_root_dir}/vcpkg")
      execute_process(COMMAND bash -c "export VCPKG_ROOT=\"${zqf_vcpkg_root_dir}\" && \"${zqf_vcpkg_root_dir}/vcpkg\" bootstrap-standalone")
    else()
      file(DOWNLOAD "${zqf_vcpkg_tool_release_url}/vcpkg-init" "${zqf_vcpkg_root_dir}/vcpkg-init")
      execute_process(COMMAND chmod +x "${zqf_vcpkg_root_dir}/vcpkg-init")
      execute_process(COMMAND bash -c "VCPKG_ROOT=\"${zqf_vcpkg_root_dir}\" && . \"${zqf_vcpkg_root_dir}/vcpkg-init\"")
    endif()
  endif()

  set(zqf_vcpkg_root_dir "${zqf_vcpkg_root_dir}" PARENT_SCOPE)
endfunction()

function(zqf_vcpkg_make_triplets zqf_vcpkg_root_dir)
  if(VCPKG_TARGET_TRIPLET MATCHES "windows-clang-cl")
    set(config_option_x64 [[set(VCPKG_CMAKE_CONFIGURE_OPTIONS "-DCMAKE_C_COMPILER=clang-cl" "-DCMAKE_CXX_COMPILER=clang-cl" "-DCMAKE_C_COMPILER_TARGET=x86_64-pc-windows-msvc" "-DCMAKE_CXX_COMPILER_TARGET=x86_64-pc-windows-msvc")]])
    set(config_option_arm64 [[set(VCPKG_CMAKE_CONFIGURE_OPTIONS "-DCMAKE_C_COMPILER=clang-cl" "-DCMAKE_CXX_COMPILER=clang-cl" "-DCMAKE_C_COMPILER_TARGET=arm64-pc-windows-msvc" "-DCMAKE_CXX_COMPILER_TARGET=arm64-pc-windows-msvc")]])

    # x64-windows-clang-cl.cmake
    file(READ "${zqf_vcpkg_root_dir}/triplets/x64-windows.cmake" content)
    file(WRITE "${zqf_vcpkg_root_dir}/triplets/x64-windows-clang-cl.cmake" "${content}${config_option_x64}")

    # x64-windows-clang-cl-static-mt.cmake
    file(READ "${zqf_vcpkg_root_dir}/triplets/x64-windows-static.cmake" content)
    file(WRITE "${zqf_vcpkg_root_dir}/triplets/x64-windows-clang-cl-static-mt.cmake" "${content}${config_option_x64}")

    # x64-windows-clang-cl-static-md.cmake
    file(READ "${zqf_vcpkg_root_dir}/triplets/x64-windows-static-md.cmake" content)
    file(WRITE "${zqf_vcpkg_root_dir}/triplets/x64-windows-clang-cl-static-md.cmake" "${content}${config_option_x64}")

    # arm64-windows-clang-cl.cmake
    file(READ "${zqf_vcpkg_root_dir}/triplets/arm64-windows.cmake" content)
    file(WRITE "${zqf_vcpkg_root_dir}/triplets/arm64-windows-clang-cl.cmake" "${content}${config_option_arm64}")

    # arm64-windows-clang-cl-static-mt.cmake
    file(READ "${zqf_vcpkg_root_dir}/triplets/community/arm64-windows-static.cmake" content)
    file(WRITE "${zqf_vcpkg_root_dir}/triplets/arm64-windows-clang-cl-static-mt.cmake" "${content}${config_option_arm64}")

    # arm64-windows-clang-cl-static-md.cmake
    file(READ "${zqf_vcpkg_root_dir}/triplets/arm64-windows-static-md.cmake" content)
    file(WRITE "${zqf_vcpkg_root_dir}/triplets/arm64-windows-clang-cl-static-md.cmake" "${content}${config_option_arm64}")
  endif()
endfunction()

if(Z_VCPKG_ROOT_DIR)
  set(zqf_vcpkg_root_dir "${Z_VCPKG_ROOT_DIR}")
else()
  zqf_vcpkg_fetch()
  zqf_vcpkg_make_triplets(${zqf_vcpkg_root_dir})
endif()

include("${zqf_vcpkg_root_dir}/scripts/buildsystems/vcpkg.cmake")
