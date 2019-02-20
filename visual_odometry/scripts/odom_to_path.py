#!/usr/bin/env python
from __future__ import print_function
import rospy
from tf.transformations import quaternion_from_euler
from std_msgs.msg import String
from nav_msgs.msg import Odometry, Path
from geometry_msgs.msg import PoseWithCovarianceStamped, PoseStamped
from sensor_msgs.msg import Joy
import sys
import json
from collections import deque

import time


def callback(data):
        global xAnt
        global yAnt
        global cont

        pose = PoseStamped()

        pose.header.frame_id = "map"
        pose.pose.position.x = float(data.pose.pose.position.x)
        pose.pose.position.y = float(data.pose.pose.position.y)
        pose.pose.position.z = float(data.pose.pose.position.z)
        pose.pose.orientation.x = float(data.pose.pose.orientation.x)
        pose.pose.orientation.y = float(data.pose.pose.orientation.y)
        pose.pose.orientation.z = float(data.pose.pose.orientation.z)
        pose.pose.orientation.w = float(data.pose.pose.orientation.w)

        if (xAnt != pose.pose.position.x and yAnt != pose.pose.position.y):
                pose.header.seq = path.header.seq + 1
                path.header.frame_id = "map"
                path.header.stamp = rospy.Time.now()
                pose.header.stamp = path.header.stamp
                path.poses.append(pose)
                # Published the msg

        cont = cont + 1

        rospy.loginfo("Hit: %i" % cont)
        if cont > max_append:
                path.poses.pop(0)

        pub.publish(path)

        xAnt = pose.pose.orientation.x
        yAnt = pose.pose.position.y
        return path


if __name__ == '__main__':
        # Initializing global variables
        global xAnt
        global yAnt
        global cont
        xAnt = 0.0
        yAnt = 0.0
        cont = 0

        # Initializing node
        rospy.init_node('path_plotter')

        # Rosparams set in the launch (can ignore if running directly from bag)
        # max size of array pose msg from the path
        if not rospy.has_param("~max_list_append"):
                rospy.logwarn('The parameter max_list_append dont exists')
        max_append = rospy.set_param("~max_list_append", 1000)
        max_append = 1000
        if not (max_append > 0):
                rospy.logwarn('The parameter max_list_append is not correct')
                sys.exit()
        pub = rospy.Publisher('/path', Path, queue_size=1)

        path = Path() 
        msg = Odometry()

        # Subscription to the required odom topic (edit accordingly)
        msg = rospy.Subscriber('/eskf_odom', Odometry, callback)

        rate = rospy.Rate(30)  # 30hz

        try:
                while not rospy.is_shutdown():
                    # rospy.spin()
                    rate.sleep()
        except rospy.ROSInterruptException:
                pass
