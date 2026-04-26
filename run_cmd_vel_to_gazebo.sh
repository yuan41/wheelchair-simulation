#!/bin/bash


# commented out the package installing stuff for Safety......

# ==========================================
# STEP 1: Dependency Checking & Installation
# ==========================================
# We include gnome-terminal to ensure we can pop open new GUI windows in Linux
# REQUIRED_PACKAGES=(
#     "socat"
#     "python3-serial"
#     "ros-humble-ros-gz-bridge"
#     "gnome-terminal"
# )

# echo "--- Checking System Dependencies ---"
# for pkg in "${REQUIRED_PACKAGES[@]}"; do
#     if ! dpkg -s "$pkg" >/dev/null 2>&1; then
#         echo "Missing package: $pkg. Prompting for installation..."
#         sudo apt-get update
#         sudo apt-get install -y "$pkg"
#     else
#         echo "[OK] $pkg is already installed."
#     fi
# done
# echo "------------------------------------"

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
    ./start_sim.sh; \
    exec bash"

sleep 4 # Give Gazebo a few seconds to boot up before trying to bridge its topics

# Window 3: ROS 2 to Ignition Bridge
gnome-terminal --title="3: ROS Bridge" -- bash -c "\
    source /opt/ros/humble/setup.bash && \
    echo 'Bridging ROS 2 /cmd_vel to Ignition...'; \
    ros2 run ros_gz_bridge parameter_bridge /cmd_vel@geometry_msgs/msg/Twist]ignition.msgs.Twist; \
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