#include "talker_listener_exercise/listener.h"

int main(int argc, char** argv)
{
  ros::init(argc, argv, "listener_node");
  talker_listener_exercise::Listener listener;
  ros::spin();
}
