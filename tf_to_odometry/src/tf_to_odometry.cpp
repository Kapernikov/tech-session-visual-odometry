#include <cstdlib>
#include <ros/init.h>
#include <tf2_ros/buffer.h>
#include <tf2_ros/transform_listener.h>
#include <nav_msgs/Odometry.h>
#include <tuple>
#include <tf2/LinearMath/Quaternion.h>
#include <tf2/LinearMath/Matrix3x3.h>
#include <tf2_geometry_msgs/tf2_geometry_msgs.h>

using std::tuple;
using std::get;
using std::string;
using tf2::fromMsg;

static tuple<bool, geometry_msgs::TransformStamped>
    maybe_get_transform(string const &parent_frame, string const &child_frame,
                        const tf2_ros::Buffer &buffer);

static geometry_msgs::TransformStamped get_transform(string const &parent_frame,
                                                     string const &child_frame,
                                                     const tf2_ros::Buffer &buffer);

tuple<bool, geometry_msgs::TransformStamped>
maybe_get_transform(string const &parent_frame, string const &child_frame,
                    const tf2_ros::Buffer &buffer) {
  bool got_transform = false;
  geometry_msgs::TransformStamped current_transformation;
  try {
    current_transformation = buffer.lookupTransform(parent_frame,
                                                    child_frame,
                                                    ros::Time::now(),
                                                    ros::Duration(1.0));
    got_transform = true;
  }
  catch (tf2::TransformException &ex) {
    ROS_WARN("error: %s", ex.what());
  }
  return tuple<bool, geometry_msgs::TransformStamped>(got_transform,
                                                      current_transformation);
}

geometry_msgs::TransformStamped get_transform(string const &parent_frame,
                                              string const &child_frame,
                                              const tf2_ros::Buffer &buffer) {
  tuple<bool, geometry_msgs::TransformStamped> prev_transform;
  get<0>(prev_transform) = false;
  while (ros::ok() && !get<0>(prev_transform)) {
    prev_transform = maybe_get_transform(parent_frame, child_frame, buffer);
  }
  return get<1>(prev_transform);
}

geometry_msgs::Vector3 operator-(geometry_msgs::Vector3 const &lhs,
                                 geometry_msgs::Vector3 const &rhs) {
  geometry_msgs::Vector3 output;
  output.x = lhs.x - rhs.x;
  output.y = lhs.y - rhs.y;
  output.z = lhs.z - rhs.z;
  return output;
}

geometry_msgs::Vector3 operator/(geometry_msgs::Vector3 const &lhs,
                                 double scalar) {
  geometry_msgs::Vector3 output;
  output.x = lhs.x / scalar;
  output.y = lhs.y / scalar;
  output.z = lhs.z / scalar;
  return output;
}

geometry_msgs::Vector3 invert_quat_rotate(geometry_msgs::Vector3 const &point,
                                          geometry_msgs::Quaternion const &quat) {
  tf2::Vector3 const tf2_point(point.x, point.y, point.z);
  tf2::Quaternion const tf2_quat(quat.x, quat.y, quat.z, quat.w);
  tf2::Vector3 const tf2_output = tf2::quatRotate(tf2_quat.inverse(), tf2_point);
  geometry_msgs::Vector3 output;
  output.x = tf2_output.getX();
  output.y = tf2_output.getY();
  output.z = tf2_output.getZ();
  return output;
}

geometry_msgs::Pose to_geometry_msgs_pose(geometry_msgs::Transform const &transform) {
  geometry_msgs::Pose output;
  output.position.x = transform.translation.x;
  output.position.y = transform.translation.y;
  output.position.z = transform.translation.z;
  output.orientation.w = transform.rotation.w;
  output.orientation.x = transform.rotation.x;
  output.orientation.y = transform.rotation.y;
  output.orientation.z = transform.rotation.z;
  return output;
}

geometry_msgs::Twist get_twist(geometry_msgs::Transform const &current_transform,
                               geometry_msgs::Transform const &previous_transform,
                               double const delta_time_s) {
  geometry_msgs::Twist output;
  geometry_msgs::Vector3 const delta_translation =
      current_transform.translation -
          previous_transform.translation;
  geometry_msgs::Vector3 const average_velocity_mps_inertial =
      delta_translation / delta_time_s;
  geometry_msgs::Vector3 const average_velocity_mps_vehicle =
      invert_quat_rotate(average_velocity_mps_inertial,
                         current_transform.rotation);
  output.linear.x = average_velocity_mps_vehicle.x;
  output.linear.y = average_velocity_mps_vehicle.y;
  output.linear.z = average_velocity_mps_vehicle.z;
  tf2::Quaternion current_quat, prev_quat;
  tf2::convert(current_transform.rotation, current_quat);
  tf2::convert(previous_transform.rotation, prev_quat);
  tf2::Quaternion const delta_quat = current_quat - prev_quat;
  double delta_roll, delta_pitch, delta_yaw;
  tf2::Matrix3x3(delta_quat).getRPY(delta_roll, delta_pitch, delta_yaw);
  output.angular.x = delta_roll / delta_time_s;
  output.angular.y = delta_pitch / delta_time_s;
  output.angular.z = delta_yaw / delta_time_s;
  return output;
}

int main(int argc, char *argv[]) {
  ros::init(argc, argv, "tf_to_odometry");

  tf2_ros::Buffer buffer;
  tf2_ros::TransformListener tf2_listener(buffer);
  ros::NodeHandle node_handle;

  ros::NodeHandle p_node_handle("~");
  string const parent_frame = p_node_handle.param("parent_frame",
                                                  string("parent_frame"));
  string const child_frame = p_node_handle.param("child_frame",
                                                 string("child_frame"));

  ros::Publisher odometry_pub(
      node_handle.advertise<nav_msgs::Odometry>("/odometry/filtered", 5));

  geometry_msgs::TransformStamped prev_transform;
  prev_transform = get_transform(parent_frame, child_frame, buffer);

  ros::Rate rate(50);

  while (ros::ok()) {
    geometry_msgs::TransformStamped current_transform(
        get_transform(parent_frame, child_frame, buffer));
    double const delta_time_s = current_transform.header.stamp.toSec() -
                                prev_transform.header.stamp.toSec();
    if (delta_time_s > 0.0) {
      nav_msgs::Odometry odometry_msg;
      odometry_msg.header = current_transform.header;
      odometry_msg.child_frame_id = current_transform.child_frame_id;
      odometry_msg.pose.pose = to_geometry_msgs_pose(current_transform.transform);
      odometry_msg.twist.twist = get_twist(current_transform.transform,
                                     prev_transform.transform, delta_time_s);
      odometry_pub.publish(odometry_msg);
    }
    prev_transform = current_transform;
    rate.sleep();
  }

  return EXIT_SUCCESS;
}
