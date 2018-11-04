# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# FindGTest
# ---------
#
# Locate GUnit C++ Testing Framework
#
# Imported targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` targets:
#
# ``GUnit::GUnit``
# The GUnit if found; adds GTest::GTest automatically
#
# ``GUnit::Main``
# Wraps GTest::Main
#
#
# Result variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project:
#
# ``GUNIT_FOUND``
#   Found the GUnit framework
# ``GUNIT_INCLUDE_DIRS``
#   the directory containing the GUnit headers
#
#
# Cache variables
# ^^^^^^^^^^^^^^^
#
# The following cache variables may also be set:
#
# ``GUNIT_ROOT``
#   The root directory of the GUnit installation (may also be
#   set as an environment variable)
#
#
# Example usage
# ^^^^^^^^^^^^^
#
# ::
#
#     find_package(GUnit REQUIRED)
#
#     add_executable(foo foo.cc)
#     target_link_libraries(foo GUnit::GUnit GUnit::Main)

find_path(GUNIT_INCLUDE_DIR GUnit.h
    HINTS
        $ENV{GUNIT_ROOT}/include
        ${GUNIT_ROOT}/include
)

mark_as_advanced(GUNIT_INCLUDE_DIR)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GUnit REQUIRED_VARS GUNIT_INCLUDE_DIR)

if(NOT GUNIT_FOUND)
    return()
endif()

message("GUnit found: " ${GUNIT_INCLUDE_DIR})
find_package(GTest REQUIRED)
find_package(nlohmann_json REQUIRED)

if (NOT TARGET GUnit::GUnit)
    add_library(GUnit::GUnit INTERFACE IMPORTED)

    # HACK to be removed when GUnit includes <nohlmann/json.hpp> instead of <json.hpp>
    get_target_property(JSON_INC_DIR nlohmann_json::nlohmann_json INTERFACE_INCLUDE_DIRECTORIES)

    set_target_properties(GUnit::GUnit PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${GUNIT_INCLUDE_DIR}
        INTERFACE_INCLUDE_DIRECTORIES "${JSON_INC_DIR}/nlohmann") # HACK
    set_target_properties(GUnit::GUnit PROPERTIES
        INTERFACE_LINK_LIBRARIES GTest::GTest
        INTERFACE_LINK_LIBRARIES nlohmann_json::nlohmann_json)
endif()

if (NOT TARGET GUnit::Main)
    add_library(GUnit::Main INTERFACE IMPORTED)
    set_target_properties(GUnit::Main PROPERTIES
        INTERFACE_LINK_LIBRARIES GTest::Main)
endif()
