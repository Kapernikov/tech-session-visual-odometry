#!/usr/bin/env python

import rospy

class Listener:
    def __init__(self):
        rospy.loginfo('listener_node: Hello World')

if __name__ == '__main__':
    rospy.init_node('listener_node', anonymous=False)
    listener = Listener()
    rospy.spin()
