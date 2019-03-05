#!/usr/bin/env python

import rospy

class Talker:
    def __init__(self):
        rospy.logerr('talker_node: Hello World')

if __name__ == '__main__':
    rospy.init_node('talker_node', anonymous=False)
    talker = Talker()
    rospy.spin()
