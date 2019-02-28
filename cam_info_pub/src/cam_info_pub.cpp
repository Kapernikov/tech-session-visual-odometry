//contains cameraInfo for snapcam.
//MUST RENAME NODE:  snap_cam_highres_publisher/image (etc) to image_raw
//MUST SET CAMFILE:  rosparam set camfile snapcam1 (etc)
#include "ros/ros.h"
#include "sensor_msgs/CameraInfo.h"
#include "sensor_msgs/CompressedImage.h"
#include "sensor_msgs/Image.h"
#include "camera_info_manager/camera_info_manager.h"
using namespace std;

/**Code adapted from
http://answers.ros.org/question/59725/publishing-to-a-topic-via-subscriber-callback-function/
  More efficient code to modify image before republishing at
http://answers.ros.org/question/53234/processing-an-image-outside-the-callback-function/
*/

int main(int argc, char **argv)
{
	ros::init(argc, argv, "publishCameraInfo");
  	ros::NodeHandle nh_; 
  	ros::Publisher cam_info_pub_ = nh_.advertise<sensor_msgs::CameraInfo>("camera_info", 1);
    
	const std::string camnameConst="snapcam1";
    const std::string camurlRead="file:///home/haumin/.ros/camera_info/snapcam1.yaml"; 
    camera_info_manager::CameraInfoManager caminfo(nh_, camnameConst,camurlRead);
    
	sensor_msgs::CameraInfo cam_info_;
    cam_info_ = caminfo.getCameraInfo();

    // Publish via image_transport
    while(ros::ok()){
		cam_info_pub_.publish(cam_info_);
  		ros::spinOnce();
	}

  	return 0;
}



