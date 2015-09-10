#------------------------------------------------------------------------------
# Extract first argument into named variable
function(qte_shift_arg variable value)
  set(${variable} "${value}" PARENT_SCOPE)
  set(ARGN "${ARGN}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
function(qte_library_include_interface target install_prefix)
  if (NOT install_prefix MATCHES "|.*/")
    set(install_prefix "${install_prefix}/")
  endif()
  foreach(path ${ARGN})
    target_include_directories(${target} SYSTEM INTERFACE
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${path}>
      $<INSTALL_INTERFACE:${install_prefix}${path}>
    )
  endforeach()
endfunction()

#------------------------------------------------------------------------------
# Mark target(s) for export
function(qte_export_targets)
  set_property(GLOBAL APPEND PROPERTY ${PROJECT_NAME}_EXPORT_TARGETS ${ARGN})
endfunction()

#------------------------------------------------------------------------------
# Install executable target to standard location and set up for export
function(qte_install_executable target component)
  qte_export_targets(${target})
  install(TARGETS ${target}
    EXPORT ${PROJECT_NAME}
    RUNTIME COMPONENT ${component} DESTINATION bin
    BUNDLE  COMPONENT ${component} DESTINATION .
  )
endfunction()

#------------------------------------------------------------------------------
# Install library target(s) to standard location and set up for export
function(qte_install_library_targets)
  qte_export_targets(${ARGN})
  install(TARGETS ${ARGN}
    EXPORT ${PROJECT_NAME}
    RUNTIME       COMPONENT Runtime     DESTINATION bin
    LIBRARY       COMPONENT Runtime     DESTINATION lib${LIB_SUFFIX}
    ARCHIVE       COMPONENT Development DESTINATION lib${LIB_SUFFIX}
    INCLUDES      COMPONENT Development DESTINATION include/QtE
    PUBLIC_HEADER COMPONENT Development DESTINATION include/QtE
  )
endfunction()
