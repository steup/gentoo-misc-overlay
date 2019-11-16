# Copyright 2018 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=6

DESCRIPTION="Metapackage to aggregate ROS dependancies for the robOTTO workspace."
HOMEPAGE="http://robotto.cs.ovgu.de/redmine"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
dev-db/sqlite3-pcre
ros-melodic/amcl
ros-melodic/bfl
ros-melodic/controller_manager_msgs
ros-melodic/costmap_2d
ros-melodic/desktop
ros-melodic/image_geometry
ros-melodic/joy
ros-melodic/map_server
ros-melodic/move_base
ros-melodic/move_base_msgs
ros-melodic/moveit
ros-melodic/moveit_msgs
ros-melodic/moveit_resources
ros-melodic/nav_core
ros-melodic/orocos_kinematics_dynamics
ros-melodic/pointcloud_to_laserscan
ros-melodic/pr2_msgs
ros-melodic/robot
ros-melodic/srdfdom
ros-melodic/tf2_geometry_msgs
ros-melodic/tf2_sensor_msgs
ros-melodic/warehouse_ros
"
DEPEND="${RDEPEND}
	ros-melodic/catkin
"

SLOT="0"
