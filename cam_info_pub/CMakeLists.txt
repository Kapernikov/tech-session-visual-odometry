cmake_minimum_required(VERSION 2.8.3)
project(cam_info_pub)

## Add support for C++11, supported in ROS Kinetic and newer
# add_definitions(-std=c++11)


## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  roscpp
  camera_info_manager
)


###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## INCLUDE_DIRS: uncomment this if you package contains header files
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need
catkin_package(
#  INCLUDE_DIRS include
#  LIBRARIES cam_info_pub:
#  CATKIN_DEPENDS roscppls
#  DEPENDS system_lib
)

###########
## Build ##
###########

## Specify additional locations of header files
## Your package locations should be listed before other locations
# include_directories(include)
include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable(publishCameraInfo src/cam_info_pub.cpp)


#target_link_libraries(makeRawImageSubPub ${catkin_LIBRARIES})
target_link_libraries(publishCameraInfo ${catkin_LIBRARIES})
#target_link_libraries(publishCameraInfoSnapcam ${catkin_LIBRARIES})
