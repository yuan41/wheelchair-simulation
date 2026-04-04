#!/bin/bash

# Get the path of the root folder (wheelchair-simulation)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Set the resource path so Gazebo sees the 'wheelchair' folder as a model source
export IGN_GAZEBO_RESOURCE_PATH=$IGN_GAZEBO_RESOURCE_PATH:$SCRIPT_DIR

echo "Launching Simulation from: $SCRIPT_DIR"

# Launch your square room world
LIBGL_ALWAYS_SOFTWARE=1 ign gazebo worlds/reduced_living_room.sdf