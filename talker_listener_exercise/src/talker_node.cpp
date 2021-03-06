#include "talker_listener_exercise/talker.h"

int main(int argc, char** argv)
{
  ros::init(argc, argv, "talker_node");
  talker_listener_exercise::Talker talker;
  ros::Rate r(5);
  while (ros::ok())
  {
    talker.publish();
    ros::spinOnce();
    r.sleep();
  }
}
