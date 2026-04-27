#!/bin/bash

# Get the path of the root folder (wheelchair-simulation)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Set the resource path so Gazebo sees the 'wheelchair' folder as a model source
export IGN_GAZEBO_RESOURCE_PATH=$IGN_GAZEBO_RESOURCE_PATH:$SCRIPT_DIR

# Check if a file argument was provided
if [ -z "$1" ]; then
    echo "Error: No SDF file specified."
    echo "Usage: ./start-wheelchair_sim.sh worlds/____.sdf"
    echo "valid arguments include: worlds/reduced_living_room.sdf, worlds/course_straight.sdf, worlds/course_curve.sdf"
    exit 1
fi

echo "Launching Simulation from: $SCRIPT_DIR"
echo "Target World: $1"

# Launch Gazebo with the provided argument
LIBGL_ALWAYS_SOFTWARE=1 ign gazebo "$1"

# LIBGL_ALWAYS_SOFTWARE=1 ign gazebo worlds/reduced_living_room.sdf