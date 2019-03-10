cmake_minimum_required(VERSION 2.8.3)
project(trajectory_evaluation)

add_compile_options(-std=c++11)

find_package(catkin REQUIRED COMPONENTS
  geometry_msgs
  nav_msgs
  rosbag
  roscpp
  rospy
  std_msgs
)

catkin_python_setup()

catkin_package(
  INCLUDE_DIRS include
  # LIBRARIES trajectory_evaluation
  CATKIN_DEPENDS
    geometry_msgs
    nav_msgs
    rosbag
    roscpp
    rospy
    std_msgs
  # DEPENDS system_lib
)

include_directories(include ${catkin_INCLUDE_DIRS})

#############
## Install ##
#############

add_library(${PROJECT_NAME} src/${PROJECT_NAME}.cpp)
target_link_libraries(${PROJECT_NAME} ${catkin_LIBRARIES})
add_executable(${PROJECT_NAME}_node src/${PROJECT_NAME}_node.cpp src/${PROJECT_NAME}.cpp)
target_link_libraries(${PROJECT_NAME}_node ${catkin_LIBRARIES})

#############
## Install ##
#############
install(
  PROGRAMS src/${PROJECT_NAME}/*.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

## Mark executables and/or libraries for installation
install(
  TARGETS ${PROJECT_NAME} ${PROJECT_NAME}_node
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

## Mark cpp header files for installation
install(
  DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
  FILES_MATCHING PATTERN "*.h"
  PATTERN ".svn" EXCLUDE
)

## Mark other files for installation (e.g. launch and bag files, etc.)
install(
  FILES launch/*.launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
