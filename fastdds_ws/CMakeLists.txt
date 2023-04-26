# Copyright 2016 Proyectos y Sistemas de Mantenimiento SL (eProsima).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project("fastdds_ws")
add_subdirectory(src/thirdparty/optionparser)

if( ${CMAKE_SYSTEM_PROCESSOR} STREQUAL "aarch64" )
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
else()
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread")
endif()

set(fastrtps_FOUND TRUE)
set(fastcdr_FOUND TRUE)
add_subdirectory(src/thirdparty/ros-data-types-for-fastdds)
add_subdirectory(src/thirdparty/tf2)
add_subdirectory(src/HeaderTest)
add_subdirectory(src/PointCloudTest)
add_subdirectory(src/ImageTest)
add_subdirectory(src/HelloWorldExample)
add_subdirectory(src/HelloWorldExampleDataSharing)
add_subdirectory(src/HelloWorldExampleSharedMem)
add_subdirectory(src/HelloWorldExampleTCP)
add_subdirectory(src/TransformStampedTest)

