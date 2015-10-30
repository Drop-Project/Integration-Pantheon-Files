# Load package
find_package (PkgConfig)

# Dependencies
pkg_check_modules (DEPS REQUIRED
    gtk+-3.0
    gee-0.8
    glib-2.0
    granite
    pantheon-files-core
    drop-1.0)

# Add definitions
add_definitions (${DEPS_CFLAGS})
link_directories (${DEPS_LIBRARY_DIRS})

# Vala
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22.0" MINIMUM)

# Precompile
include (ValaPrecompile)
vala_precompile (VALA_C ${CMAKE_PROJECT_NAME}
    Plugin.vala
PACKAGES
    gtk+-3.0
    gee-0.8
    granite
    pantheon-files-core
    drop-1.0
OPTIONS
    --thread
)

# Add library
add_library (${CMAKE_PROJECT_NAME} MODULE ${VALA_C})
target_link_libraries(${CMAKE_PROJECT_NAME} ${DEPS_LIBRARIES})

# Installation
install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION ${PLUGIN_DIR}/core/)
install (FILES drop.plug DESTINATION ${PLUGIN_DIR}/core/)