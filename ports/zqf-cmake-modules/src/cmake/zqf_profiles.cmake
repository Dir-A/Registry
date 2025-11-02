include_guard(GLOBAL)

function(zqf_profiles)
  if(NOT EXISTS "${CMAKE_SOURCE_DIR}/.clangd")
    file(COPY_FILE "${CMAKE_CURRENT_LIST_DIR}/profiles/.clangd" "${CMAKE_SOURCE_DIR}/.clangd")
  endif()

  if(NOT EXISTS "${CMAKE_SOURCE_DIR}/.clang-format")
    file(COPY_FILE "${CMAKE_CURRENT_LIST_DIR}/profiles/.clang-format" "${CMAKE_SOURCE_DIR}/.clang-format")
  endif()

  if(NOT EXISTS "${CMAKE_SOURCE_DIR}/.editorconfig")
    file(COPY_FILE "${CMAKE_CURRENT_LIST_DIR}/profiles/.editorconfig" "${CMAKE_SOURCE_DIR}/.editorconfig")
  endif()
endfunction()

zqf_profiles()
