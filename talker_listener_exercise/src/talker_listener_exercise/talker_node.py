#!/usr/bin/env python

import rospy

class Talker:
    def __init__(self):
        rospy.loginfo('talker_node: Hello World')

    def publish(self):
        pass

if __name__ == '__main__':
    rospy.init_node('talker_node', anonymous=False)
    talker = Talker()
    r = rospy.Rate(5)
    while not rospy.is_shutdown():
        talker.publish()
        r.sleep()
