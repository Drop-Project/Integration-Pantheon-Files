cmake_minimum_required (VERSION 2.6)
cmake_policy (VERSION 2.6)

# Projectname
project (pantheon-files-drop)

# Configuration
include (GNUInstallDirs)
set (PKGDATADIR "${DATADIR}")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}-plugin")
set (PLUGIN_DIR "${CMAKE_INSTALL_PREFIX}/lib/x86_64-linux-gnu/pantheon-files/plugins")
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Gettext
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Comment this out to enable C compiler warnings
add_definitions (-w)

# Files
file (GLOB resources "${CMAKE_CURRENT_SOURCE_DIR}/data/*")

# Include directories
add_subdirectory (src)
add_subdirectory (po)

# Uninstall target
configure_file(
    "${CMAKE_SOURCE_DIR}/cmake/Uninstall.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/Uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/Uninstall.cmake)
