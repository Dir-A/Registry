include_guard(GLOBAL)

function(zqf_doxygen TARGET_NAME)
  # ArgParse
  set(options)
  set(multiValueArgs)
  set(oneValueArgs
    TARGET_DIR
    OUTPUT_DIR
  )
  cmake_parse_arguments(ZQF "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  get_target_property(ZQF_TARGET_DIR ${TARGET_NAME} SOURCE_DIR)

  if(NOT ZQF_OUTPUT_DIR)
    set(ZQF_OUTPUT_DIR ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/docs)
  endif()

  find_package(Doxygen)

  if(NOT DOXYGEN_FOUND)
    add_custom_target(doxygen COMMAND false COMMENT "Doxygen not found")
    return()
  endif()

  set(DOXYGEN_EXTRACT_ALL YES)
  set(DOXYGEN_UML_LOOK YES)
  set(DOXYGEN_GENERATE_HTML YES)
  set(DOXYGEN_GENERATE_TREEVIEW YES)
  set(DOXYGEN_HAVE_DOT YES)
  set(DOXYGEN_DOT_TRANSPARENT YES)
  set(DOXYGEN_DOT_IMAGE_FORMAT svg)
  set(DOXYGEN_DOT_TRANSPARENT YES)
  set(DOXYGEN_HTML_OUTPUT ${ZQF_OUTPUT_DIR})

  # UseDoxygenAwesomeCss
  include(FetchContent)
  FetchContent_Declare(
    doxygen-awesome-css
    GIT_REPOSITORY https://github.com/jothepro/doxygen-awesome-css.git
    GIT_TAG v2.3.4
    GIT_SHALLOW TRUE
    GIT_DEPTH 1
  )
  FetchContent_MakeAvailable(doxygen-awesome-css)
  set(DOXYGEN_DISABLE_INDEX NO)
  set(DOXYGEN_FULL_SIDEBAR NO)
  set(DOXYGEN_HTML_COLORSTYLE LIGHT)
  set(DOXYGEN_HTML_EXTRA_STYLESHEET ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome.css ${doxygen-awesome-css_SOURCE_DIR}/doxygen-awesome-sidebar-only.css)

  doxygen_add_docs(doxygen ${ZQF_TARGET_DIR} COMMENT "Generate HTML documentation")
endfunction()
