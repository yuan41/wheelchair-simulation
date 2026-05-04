#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Verify STM32 is connected before launching anything
if [ ! -e /dev/ttyACM0 ]; then
    echo "ERROR: /dev/ttyACM0 not found. Is the STM32 connected and usbipd attached?"
    exit 1
fi

echo "STM32 detected on /dev/ttyACM0"
echo "Launching pipeline windows..."

gnome-terminal --title="1: Gazebo Simulator" -- bash -c "\
    cd $ROOT_DIR && \
    ./start_wheelchair_sim.sh worlds/reduced_living_room.sdf; \
    exec bash"

sleep 18

gnome-terminal --title="2: ROS Bridge" -- bash -c "\
    source /opt/ros/humble/setup.bash && \
    echo 'Bridging /cmd_vel and /model/my_wheelchair/odometry...'; \
    ros2 run ros_gz_bridge parameter_bridge \
        /cmd_vel@geometry_msgs/msg/Twist]ignition.msgs.Twist \
        /model/my_wheelchair/odometry@nav_msgs/msg/Odometry[ignition.msgs.Odometry; \
    exec bash"

sleep 2

gnome-terminal --title="3: ROS Node (STM32)" -- bash -c "\
    source /opt/ros/humble/setup.bash && \
    cd $ROOT_DIR/scripts && \
    echo 'Reading from /dev/ttyACM0 -> publishing /cmd_vel...'; \
    python3 control_temp.py; \
    exec bash"

echo "All windows launched. Watch Terminal 3 for Published: messages."