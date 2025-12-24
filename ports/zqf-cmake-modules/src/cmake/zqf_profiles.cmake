include_guard(GLOBAL)

function(zqf_profiles_fetch)
  # ArgParse
  set(options
    CLANGD
    EDITOR_CONFIG
  )
  set(multiValueArgs)
  set(oneValueArgs)
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(ZQF_CLANGD)
    file(COPY ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/profiles/.clang-format DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})
    file(COPY ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/profiles/.clangd DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  if(ZQF_EDITOR_CONFIG)
    file(COPY ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/profiles/.editorconfig DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})
  endif()
endfunction()
