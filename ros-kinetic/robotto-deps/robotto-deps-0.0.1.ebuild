# Copyright 2018 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=6

DESCRIPTION="Metapackage to aggregate ROS dependancies for the robOTTO workspace."
HOMEPAGE="http://robotto.cs.ovgu.de/redmine"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
dev-db/sqlite3-pcre
dev-lang/clipsmm
ros-kinetic/amcl
ros-kinetic/bfl
ros-kinetic/controller_manager_msgs
ros-kinetic/cost_map
ros-kinetic/desktop
ros-kinetic/image_geometry
ros-kinetic/joy
ros-kinetic/manipulation_msgs
ros-kinetic/map_server
ros-kinetic/move_base
ros-kinetic/move_base_msgs
ros-kinetic/moveit
ros-kinetic/moveit_resources
ros-kinetic/nav_core
ros-kinetic/orocos_kinematics_dynamics
ros-kinetic/pointcloud_to_laserscan
ros-kinetic/pr2_msgs
ros-kinetic/robot
ros-kinetic/srdfdom
ros-kinetic/tf2_geometry_msgs
ros-kinetic/tf2_sensor_msgs
ros-kinetic/warehouse_ros
<sci-libs/tensorflow-1.15
"
DEPEND="${RDEPEND}
	ros-kinetic/catkin
"

SLOT="0"
