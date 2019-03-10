#!/usr/bin/env python

import rospy

class TrajectoryEvaluation:
    def __init__(self):
        rospy.loginfo('trajectory_evaluation_node: Hello World')

if __name__ == '__main__':
    rospy.init_node('trajectory_evaluation_node', anonymous=False)
    te = TrajectoryEvaluation()
    rospy.spin()
