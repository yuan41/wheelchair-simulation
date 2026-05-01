#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Launching pipeline windows..."

gnome-terminal --title="1: Virtual Serial Cable" -- bash -c "\
    echo 'Creating virtual ports /tmp/ttyV0 and /tmp/ttyV1...'; \
    socat pty,raw,echo=0,link=/tmp/ttyV0 pty,raw,echo=0,link=/tmp/ttyV1; \
    exec bash"

sleep 1

gnome-terminal --title="2: Gazebo Simulator" -- bash -c "\
    cd $ROOT_DIR && \
    ./start_wheelchair_sim.sh worlds/reduced_living_room.sdf; \
    exec bash"

sleep 8

gnome-terminal --title="3: ROS Bridge" -- bash -c "\
    source /opt/ros/humble/setup.bash && \
    echo 'Bridging ROS 2 /cmd_vel and /model/my_wheelchair/odometry...'; \
    ros2 run ros_gz_bridge parameter_bridge \
        /cmd_vel@geometry_msgs/msg/Twist]ignition.msgs.Twist \
        /model/my_wheelchair/odometry@nav_msgs/msg/Odometry[ignition.msgs.Odometry; \
    exec bash"

sleep 1

gnome-terminal --title="4: ROS Node" -- bash -c "\
    source /opt/ros/humble/setup.bash && \
    cd $ROOT_DIR/scripts && \
    echo 'Starting ROS 2 translation node...'; \
    python3 weight_to_cmd_vel.py; \
    exec bash"

sleep 2

gnome-terminal --title="5: C Control Sender" -- bash -c "\
    cd $ROOT_DIR && \
    echo 'Piping C control output to /tmp/ttyV0...'; \
    ./scripts/C/control > /tmp/ttyV0; \
    exec bash"