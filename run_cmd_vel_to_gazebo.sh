#!/bin/bash

# ==========================================
# STEP 2: Launching the Pipeline Windows
# ==========================================
# Get the absolute path of the current directory
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Launching pipeline windows..."

# Window 1: Virtual Serial Cable
# Note: "exec bash" keeps the window open so you can read errors if it crashes
gnome-terminal --title="1: Virtual Serial Cable" -- bash -c "\
    echo 'Creating virtual ports /tmp/ttyV0 and /tmp/ttyV1...'; \
    socat pty,raw,echo=0,link=/tmp/ttyV0 pty,raw,echo=0,link=/tmp/ttyV1; \
    exec bash"

sleep 1 # Wait a second for ports to establish

# Window 2: Gazebo Simulator
gnome-terminal --title="2: Gazebo Simulator" -- bash -c "\
    cd $ROOT_DIR && \
    ./start_wheelchair_sim.sh worlds/reduced_living_room.sdf; \
    exec bash"

sleep 4 # Give Gazebo a few seconds to boot up before trying to bridge its topics

# Window 3: ROS 2 to Gazebo Bridge
gnome-terminal --title="3: ROS Bridge" -- bash -c "\
    source /opt/ros/humble/setup.bash && \
    echo 'Bridging ROS 2 /cmd_vel and /model/my_wheelchair/odometry...'; \
    ros2 run ros_gz_bridge parameter_bridge /cmd_vel@geometry_msgs/msg/Twist]ignition.msgs.Twist /model/my_wheelchair/odometry@nav_msgs/msg/Odometry[ignition.msgs.Odometry
    exec bash"

# Window 4: Mock Serial Sender
gnome-terminal --title="4: Mock Sender" -- bash -c "\
    cd $ROOT_DIR/scripts && \
    echo 'Starting fake hardware serial sender...'; \
    python3 mock_serial_sender.py; \
    exec bash"

# Window 5: ROS 2 Control Node
gnome-terminal --title="5: ROS Node" -- bash -c "\
    source /opt/ros/humble/setup.bash && \
    cd $ROOT_DIR/scripts && \
    echo 'Starting ROS 2 translation node...'; \
    python3 weight_to_cmd_vel.py; \
    exec bash"

echo "All pipeline components launched successfully!"