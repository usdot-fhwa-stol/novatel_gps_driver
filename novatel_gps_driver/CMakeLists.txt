cmake_minimum_required(VERSION 2.8.3)

project(novatel_gps_driver)

find_package(carma_cmake_common REQUIRED)
carma_check_ros_version(1)
carma_package()

set(DEPS
  diagnostic_msgs 
  diagnostic_updater 
  gps_common
  nav_msgs 
  nodelet 
  novatel_gps_msgs
  roscpp
  sensor_msgs
  std_msgs
  swri_math_util 
  swri_roscpp
  swri_serial_util
  swri_string_util 
  tf
  cav_msgs
  carma_utils
  uncertainty_tools
)

set(BUILD_DEPENDS
  ${DEPS}
  swri_nodelet
)

find_package(catkin REQUIRED COMPONENTS ${BUILD_DEPENDS})

find_package(Boost REQUIRED COMPONENTS system)

include_directories(include
  ${catkin_INCLUDE_DIRS}
)

# libpcap doesn't provide PkgConfig or CMake modules
find_library(libpcap_LIBRARIES pcap)
if ("${libpcap_LIBRARIES}" STREQUAL "pcap-NOTFOUND")
  set(libpcap_FOUND FALSE)
else()
  set(libpcap_FOUND TRUE)
endif()

catkin_package(CATKIN_DEPENDS ${DEPS}
  INCLUDE_DIRS include
  LIBRARIES ${PROJECT_NAME} ${PROJECT_NAME}_nodelets
  DEPENDS Boost libpcap
)

add_library(${PROJECT_NAME} 
  src/novatel_gps.cpp
  src/novatel_message_extractor.cpp
  src/parsers/bestpos.cpp
  src/parsers/bestutm.cpp
  src/parsers/bestvel.cpp
  src/parsers/bestxyz.cpp
  src/parsers/clocksteering.cpp
  src/parsers/corrimudata.cpp
  src/parsers/dual_antenna_heading.cpp
  src/parsers/gpgga.cpp
  src/parsers/gpgsa.cpp
  src/parsers/gpgsv.cpp
  src/parsers/gphdt.cpp
  src/parsers/gprmc.cpp
  src/parsers/header.cpp
  src/parsers/heading2.cpp
  src/parsers/inscov.cpp
  src/parsers/inspva.cpp
  src/parsers/inspvax.cpp
  src/parsers/insstdev.cpp
  src/parsers/parsing_utils.cpp
  src/parsers/psrdop2.cpp
  src/parsers/range.cpp
  src/parsers/time.cpp
  src/parsers/trackstat.cpp
)

add_dependencies(${PROJECT_NAME} ${catkin_EXPORTED_TARGETS})

target_link_libraries(${PROJECT_NAME}
  ${catkin_LIBRARIES}
  ${Boost_LIBRARIES}
  ${libpcap_LIBRARIES}
)
set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "-std=c++14")

add_dependencies(${PROJECT_NAME} ${catkin_EXPORTED_TARGETS})

### Nodelets ###
add_library(${PROJECT_NAME}_nodelets 
  src/nodelets/novatel_gps_nodelet.cpp
  src/nodelets/wrapper/novatel_gps_nodelet_wrapper.cpp
  src/nodelets/wrapper/novatel_gps_nodelet_wrapper_worker.cpp
  
)
target_link_libraries(${PROJECT_NAME}_nodelets
  ${catkin_LIBRARIES}
  ${PROJECT_NAME}
)
set_target_properties(${PROJECT_NAME}_nodelets PROPERTIES COMPILE_FLAGS "-std=c++14")

### Nodes ###
swri_nodelet_add_node(novatel_gps_node ${PROJECT_NAME} NovatelGpsNodelet)
target_link_libraries(novatel_gps_node
  ${catkin_LIBRARIES}
  ${PROJECT_NAME}_nodelets
)
set_target_properties(novatel_gps_node PROPERTIES COMPILE_FLAGS "-std=c++14")

### Build unit tests
if(CATKIN_ENABLE_TESTING)
  find_package(rostest REQUIRED)

  catkin_add_gtest(parser_tests test/parser_tests.cpp)
  target_link_libraries(parser_tests ${PROJECT_NAME})
  set_target_properties(parser_tests PROPERTIES COMPILE_FLAGS "-std=c++14")

  catkin_add_gmock(wrapper_tests test/wrapper/gps_nodelet_wrapper_worker_test.cpp)
  target_link_libraries(wrapper_tests ${PROJECT_NAME}_nodelets )
  set_target_properties(wrapper_tests PROPERTIES COMPILE_FLAGS "-std=c++14")

  #  target_link_libraries(novatel_DriverDiscovery_gtest ${PROJECT_NAME} ${catkin_LIBRARIES})
  # add_dependencies( novatel_DriverDiscovery_gtest ${catkin_EXPORTED_TARGETS})
  # set_target_properties(novatel_DriverDiscovery_gtest PROPERTIES COMPILE_FLAGS "-std=c++14")

  add_rostest_gtest(novatel_gps_tests test/novatel_gps_tests.test test/novatel_gps_tests.cpp)
  target_link_libraries(novatel_gps_tests ${PROJECT_NAME})
  set_target_properties(novatel_gps_tests PROPERTIES COMPILE_FLAGS "-std=c++14")
endif()

### Install Libraries and Headers ###
install(TARGETS 
    novatel_gps_node
    ${PROJECT_NAME} 
    ${PROJECT_NAME}_nodelets
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
)

### Install plugin XML ###
install(FILES nodelet_plugins.xml
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

### Install Launch Files ###
install(DIRECTORY launch config DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})


