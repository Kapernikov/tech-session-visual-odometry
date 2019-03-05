cmake_minimum_required(VERSION 2.8.3)
project(talker_listener_exercise)

add_compile_options(-std=c++11)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
)

catkin_python_setup()

catkin_package(
 INCLUDE_DIRS include
 # LIBRARIES talker_listener_exercise
 CATKIN_DEPENDS
  roscpp
  rospy
  std_msgs
 # DEPENDS system_lib
)

include_directories(include ${catkin_INCLUDE_DIRS})

#############
## Install ##
#############

add_library(talker src/talker.cpp)
target_link_libraries(talker ${catkin_LIBRARIES})
add_executable(talker_node src/talker_node.cpp src/talker.cpp)
target_link_libraries(talker_node ${catkin_LIBRARIES})

add_library(listener src/listener.cpp)
target_link_libraries(listener ${catkin_LIBRARIES})
add_executable(listener_node src/listener_node.cpp src/listener.cpp)
target_link_libraries(listener_node ${catkin_LIBRARIES})

#############
## Install ##
#############
install(
  PROGRAMS src/${PROJECT_NAME}/*.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

## Mark executables and/or libraries for installation
install(
  TARGETS talker talker_node
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
