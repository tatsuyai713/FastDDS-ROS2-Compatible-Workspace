cmake_minimum_required(VERSION 3.1)

project(gazebo_msgs VERSION 1.0.0 LANGUAGES CXX)

include(${PROJECT_SOURCE_DIR}/../../cmake/dds_utils.cmake)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=deprecated-declarations -Wno-error=unused-result -Wnon-virtual-dtor -ggdb -MMD -MP -fPIC -fno-strict-aliasing -Wall -W -Wpointer-arith -D_GNU_SOURCE")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

file(GLOB_RECURSE Original_IDL_Files
  "${CMAKE_CURRENT_SOURCE_DIR}/*/*.idl"
)
CREATE_IDL_FILES_COMMAND(${Original_IDL_Files})
file(GLOB_RECURSE Local_IDL_Files
  "${CMAKE_CURRENT_BINARY_DIR}/*.idl"
)
file(GLOB_RECURSE in1_files
  "${CMAKE_CURRENT_BINARY_DIR}/*.cxx"
  "${CMAKE_CURRENT_BINARY_DIR}/*.h"
)
if (NOT in1_files)
    #create an initial version of these files
    COMPILE_IDL_FILES(${Original_IDL_Files})
    file(GLOB_RECURSE in1_files
      "${CMAKE_CURRENT_BINARY_DIR}/*.cxx"
      "${CMAKE_CURRENT_BINARY_DIR}/*.h"
    )
endif()
add_custom_target(gazebo_msgs_CompileIDLFiles ALL
    DEPENDS ${ALL_IDL_SRCS})
add_definitions(${DDS_DEFINITIONS})
add_library(gazebo_msgs SHARED
    ${in1_files}
)
add_dependencies(gazebo_msgs gazebo_msgs_CompileIDLFiles)

include_directories("${CMAKE_CURRENT_BINARY_DIR}" 
  "${CMAKE_CURRENT_BINARY_DIR}/../diagnostic_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../gazebo_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../geometry_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../lifecycle_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../nav_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../pendulum_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../sensor_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../shape_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../std_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../stereo_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../test_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../tf2_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../trajectory_msgs"
  "${CMAKE_CURRENT_BINARY_DIR}/../visualization_msgs"
  ${PROJECT_BINARY_DIR}
)

target_link_libraries(gazebo_msgs LINK_PUBLIC -Wl,--allow-multiple-definition fastcdr fastrtps)

target_include_directories(gazebo_msgs PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
  $<INSTALL_INTERFACE:include> 
)

install(TARGETS gazebo_msgs
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/gazebo_msgs DESTINATION include/)
