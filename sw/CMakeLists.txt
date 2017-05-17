cmake_minimum_required (VERSION 3.5)

project (sobel_filter)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})

set(SOBEL_NAME sobel_filter)

#------------------------------------------------------------------------------
# Package: PNG
#------------------------------------------------------------------------------
find_package(PNG REQUIRED)
include_directories(${PNG_INCLUDE_DIR})
set(LIBS ${LIBS} ${PNG_LIBRARY})

#------------------------------------------------------------------------------
# Package: Boost
#------------------------------------------------------------------------------
find_package(Boost COMPONENTS program_options REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})
set(LIBS ${LIBS} Boost::program_options)

#-------------------------------------------------------------------------------
# Flags
#-------------------------------------------------------------------------------
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -std=c++11 -g")

#-------------------------------------------------------------------------------
# Include
#-------------------------------------------------------------------------------
include_directories(${CMAKE_MODULE_PATH})

#-------------------------------------------------------------------------------
# Exec
#-------------------------------------------------------------------------------
file(GLOB SOURCES "src/*.cpp")

add_executable(${SOBEL_NAME} ${SOURCES})

target_link_libraries(${SOBEL_NAME} ${LIBS})

#-------------------------------------------------------------------------------
# Tests
#-------------------------------------------------------------------------------
