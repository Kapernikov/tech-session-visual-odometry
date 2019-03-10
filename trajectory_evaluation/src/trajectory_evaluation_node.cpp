#include "trajectory_evaluation/trajectory_evaluation.h"

int main(int argc, char** argv)
{
  ros::init(argc, argv, "trajectory_evaluation_node");
  trajectory_evaluation::TrajectoryEvaluation te;
  ros::spin();
}
