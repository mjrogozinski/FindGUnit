# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:

find_path(GHERKIN_INCLUDE_DIR gherkin.hpp
    HINTS
        $ENV{GHERKIN_ROOT}/include
        ${GHERKIN_ROOT}/include
        $ENV{GUNIT_ROOT}/libs/gherkin-cpp/include
        ${GUNIT_ROOT}/libs/gherkin-cpp/include
)

find_path(GHERKIN_LIB_DIR libgherkin-cpp.a
    HINTS
        $ENV{GHERKIN_ROOT}
        ${GHERKIN_ROOT}
        $ENV{GUNIT_ROOT}/libs/gherkin-cpp
        ${GUNIT_ROOT}/libs/gherkin-cpp
)


mark_as_advanced(GHERKIN_INCLUDE_DIR)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GHERKIN REQUIRED_VARS GHERKIN_INCLUDE_DIR GHERKIN_LIB_DIR)

if(NOT GHERKIN_FOUND)
    return()
endif()

message("gherkin found: " ${GHERKIN_INCLUDE_DIR} " libs: " ${GHERKIN_LIB_DIR})

if (NOT TARGET gherkin::gherkin)
    add_library(gherkin::gherkin INTERFACE IMPORTED)
    set_target_properties(gherkin::gherkin PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${GHERKIN_INCLUDE_DIR})
    set_target_properties(gherkin::gherkin PROPERTIES
        INTERFACE_LINK_LIBRARIES GTest::GTest)
    set_target_properties(gherkin::gherkin PROPERTIES
        INTERFACE_LINK_LIBRARIES ${GHERKIN_LIB_DIR}/libgherkin-cpp.a)

endif()
