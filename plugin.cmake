if (PLUGIN_NAME STREQUAL "")
	set (PLUGIN_NAME "${CMAKE_PROJECT_NAME}")
endif (PLUGIN_NAME STREQUAL "")

include_directories("${VACUUM_SDK_PATH}")

if(POLICY CMP0020)
	cmake_policy(SET CMP0020 NEW)
endif()

if (WIN32)
	set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif (WIN32)

add_definitions(-DQT_PLUGIN -DQT_SHARED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

if (LOCALIZED_LANGS)
    add_translations(TRANSLATIONS ${PLUGIN_NAME} ${HEADERS} ${SOURCES} ${UIS})
endif(LOCALIZED_LANGS)
add_library(${PLUGIN_NAME} SHARED ${SOURCES} ${MOC_SOURCES} ${UI_HEADERS} ${RCC_SOURCES} ${TRANSLATIONS})

if (NOT UTILS_LIB)
	find_library(UTILS_LIB vacuumutils ${VACUUM_LIB_PATH})
endif (NOT UTILS_LIB)

target_link_libraries(${PLUGIN_NAME} ${UTILS_LIB} ${QT_LIBRARIES} ${ADD_LIBS})

if (WIN32)
	install(TARGETS ${PLUGIN_NAME}
		RUNTIME DESTINATION "${INSTALL_PLUGINS}")
else (WIN32)
	install(TARGETS ${PLUGIN_NAME}
		LIBRARY DESTINATION "${INSTALL_PLUGINS}")
endif (WIN32)

# uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
