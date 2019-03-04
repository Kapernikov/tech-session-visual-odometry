#include <ros/ros.h>
#include <sensor_msgs/CameraInfo.h>
#include <std_msgs/String.h>
#include <camera_info_manager/camera_info_manager.h>

class CamInfoPub
{
  public:
    CamInfoPub() : nh_(""), pnh_("~")
    {
      std::string cam_name, frame_id, cam_info_path;
      pnh_.param<std::string>("cam_name", cam_name, "camera");
      pnh_.param<std::string>("frame_id", frame_id, "camera_optical_link");
      pnh_.param<std::string>("cam_info_path", cam_info_path, "camera_info/camera.yaml");
      std::string path = "file://${ROS_HOME}/" + cam_info_path;
      camera_info_manager::CameraInfoManager cam_info_mngr(nh_, cam_name, path);
      cam_info_ = cam_info_mngr.getCameraInfo();
      cam_info_sub_ = nh_.subscribe<sensor_msgs::CameraInfo>("camera_info_raw", 10, &CamInfoPub::camInfoCB, this);
      cam_info_pub_ = nh_.advertise<sensor_msgs::CameraInfo>("camera_info", 10);
    }

    ~CamInfoPub(){}

    void camInfoCB(const sensor_msgs::CameraInfoConstPtr& cam_info_raw)
    {
      cam_info_.header = cam_info_raw->header;
      cam_info_pub_.publish(cam_info_);
    }

  private:
    ros::NodeHandle nh_;
    ros::NodeHandle pnh_;
    ros::Publisher cam_info_pub_;
    ros::Subscriber cam_info_sub_;
    sensor_msgs::CameraInfo cam_info_;
};

int main(int argc, char **argv)
{
  ros::init(argc, argv, "cam_info_publisher_node");
  CamInfoPub cIPub;
  ros::spin();
  return 0;
  }
