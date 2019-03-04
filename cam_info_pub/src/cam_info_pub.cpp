#include "ros/ros.h"
#include "sensor_msgs/CameraInfo.h"
#include "camera_info_manager/camera_info_manager.h"
using namespace std;

int main(int argc, char **argv)
{
  ros::init(argc, argv, "cam_info_publisher_node");
  ros::NodeHandle nh;

  std::string camera_name;
  if (!nh.getParam("camera_name", camera_name))
  {
    ROS_ERROR("camera_name is not set in the parameter server");
    exit(EXIT_FAILURE);
  }
  ros::Publisher cam_info_pub = nh.advertise<sensor_msgs::CameraInfo>("camera_info", 1);
  
  std::string cam_info_path;
  if (!nh.getParam("cam_info_path", cam_info_path))
  {
    ROS_ERROR("cam_info_path is not set in the parameter server");
    exit(EXIT_FAILURE);
  }

  camera_info_manager::CameraInfoManager cam_info_mngr(nh, camera_name, "file:///"+cam_info_path);

  sensor_msgs::CameraInfo cam_info;
  cam_info = cam_info_mngr.getCameraInfo();

  while(ros::ok())
  {
    cam_info_pub.publish(cam_info);
    ros::spinOnce();
  }

  return 0;
}



