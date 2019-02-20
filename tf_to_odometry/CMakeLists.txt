cmake_minimum_required(VERSION 2.8.3)
project(tf_to_odometry)

find_package(catkin REQUIRED COMPONENTS roscpp tf2 tf2_ros tf2_geometry_msgs
        nav_msgs)

catkin_package(
  CATKIN_DEPENDS tf2 tf2_ros tf2_geometry_msgs nav_msgs
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)
add_definitions("-std=c++11 -Werror")

add_executable(tf_to_odometry src/tf_to_odometry.cpp)
target_link_libraries(tf_to_odometry ${catkin_LIBRARIES})
add_dependencies(tf_to_odometry ${catkin_EXPORTED_TARGETS})
