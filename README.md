

### Installation Requirement:

1. Ubuntu 22.04
2. Gazebo Fortress
3. ROS Humble

### 2. Binary Installation on Ubuntu

Below section is installation instructions from Gazebo Official website with some modification tailored for this repository.

Fortress binaries are provided for Ubuntu Bionic, Focal and Jammy. All of the Fortress binaries are hosted in the osrfoundation repository. To install all of them, the metapackage `ignition-fortress` can be installed.

First install some necessary tools:

```shell
sudo apt-get update
sudo apt-get install lsb-release gnupg
```

Then install Ignition Fortress:

```bash
sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update
sudo apt-get install ignition-fortress
```

All libraries should be ready to use.

To run Gazebo Fortress:

```shell
LIBGL_ALWAYS_SOFTWARE=1 ign gazebo empty.sdf
```

Replace `empty.sdf` with the simulation description format file (Sdf) you wish to run.

### 3. Binary Installation of ROS 2 on Ubuntu

Follow instructions in: [Ubuntu (deb packages) — ROS 2 Documentation: Humble documentation](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html)

---

#### Install Gnome Text Editor

 `sudo apt install gnome-terminal`

#### Package Instllations
Run these commands one by one. Ubuntu may ask for user password to install any package:
`sudo apt install socat`
`sudo apt install python3`
`sudo apt python3-serial`
`sudo apt ros-humble-ros-gz-bridge`
`sudo apt gnome-terminal`
