cmake_minimum_required(VERSION 2.8.3)
project(cam_info_pub)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  camera_info_manager
  sensor_msgs
)

catkin_package(
  CATKIN_DEPENDS
    roscpp
    camera_info_manager
    sensor_msgs
)

include_directories(${catkin_INCLUDE_DIRS})
add_executable(cam_info_pub_node src/cam_info_pub.cpp)
target_link_libraries(pub_cam_info ${catkin_LIBRARIES})
