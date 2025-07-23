# Kinova Gen3 Docker Workspace

A complete, containerized development and simulation environment for Kinova Gen3 and Gen3 Lite robotic arms, supporting ROS Noetic, MoveIt!, Gazebo, and vision modules. This workspace enables rapid development, testing, and deployment of Kinova robots in both real and simulated environments.

---

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Supported Hardware](#supported-hardware)
- [Workspace Structure](#workspace-structure)
- [Docker Environment](#docker-environment)
- [Dependencies](#dependencies)
- [Building the Workspace](#building-the-workspace)
- [Usage](#usage)
  - [Launching the Driver](#launching-the-driver)
  - [Simulation with Gazebo](#simulation-with-gazebo)
  - [Motion Planning with MoveIt!](#motion-planning-with-moveit)
  - [Vision Module](#vision-module)
  - [Running Examples](#running-examples)
- [Customization and Extension](#customization-and-extension)
- [Troubleshooting](#troubleshooting)
- [Licensing and Credits](#licensing-and-credits)
- [References](#references)

---

## Overview
This repository provides a ready-to-use Dockerized ROS workspace for Kinova Gen3 and Gen3 Lite robots. It includes:
- ROS Noetic packages for robot control, simulation, and vision
- MoveIt! motion planning
- Gazebo simulation
- Example code in C++ and Python
- Support for multiple robot and gripper configurations
- Vision module integration

## Features
- **Containerized Development:** Reproducible environment using Docker for easy setup and deployment.
- **Full ROS Integration:** Drivers, descriptions, and control packages for Kinova Gen3/Gen3 Lite arms and grippers.
- **Simulation:** Gazebo support with realistic controllers and plugins for grippers.
- **Motion Planning:** MoveIt! configuration for all supported robot/gripper combinations.
- **Vision:** Access to Kinova Vision module streams and calibration tools.
- **Examples:** Ready-to-run launch files and scripts for common tasks.

## Supported Hardware
- Kinova Gen3 (6DOF and 7DOF)
- Kinova Gen3 Lite (6DOF)
- Grippers: Robotiq 2F-85, Robotiq 2F-140, Gen3 Lite 2F
- Kinova Vision Module

## Workspace Structure
```
kinova-gen3-docker/
├── docker/                # Dockerfile, apt and pip requirements
├── kinova_ws/             # ROS workspace
│   └── src/
│       ├── ros_kortex/    # Main Kinova ROS packages
│       │   ├── kortex_api/         # C++ API, protobufs
│       │   ├── kortex_control/     # Control configs
│       │   ├── kortex_description/ # URDF/Xacro, meshes
│       │   ├── kortex_driver/      # Main ROS driver
│       │   ├── kortex_examples/    # Example code
│       │   ├── kortex_gazebo/      # Gazebo simulation
│       │   └── kortex_move_it_config/ # MoveIt! configs
│       └── ros_kortex_vision/      # Vision module integration
├── scripts/               # Utility scripts
├── Makefile               # Build helper
└── README.md              # This file
```

## Docker Environment
The provided Dockerfile sets up Ubuntu 20.04 with ROS Noetic, Python, Bazel, TensorFlow Object Detection dependencies, and all required system and Python packages.

### Key Docker Features
- Installs all apt and pip dependencies for ROS, vision, and machine learning
- Sets up ROS networking environment variables
- Installs Bazel and TensorFlow Object Detection API
- Prepares for both simulation and real hardware use

**To build the Docker image:**
```bash
docker build -t kinova-gen3-dev -f docker/Dockerfile .
```

**To run the container:**
```bash
docker run -it --rm --net=host --privileged \
  -v $(pwd)/kinova_ws:/root/kinova_ws \
  kinova-gen3-dev
```

## Dependencies
### System (apt)
See `docker/apt_packages.pkg` for a full list. Key packages include:
- build-essential, git, curl, wget, unzip, openjdk-8-jdk
- ROS Noetic: desktop-full, python3-rosdep, python3-rosinstall, python3-wstool, python3-colcon-common-extensions
- GStreamer (for vision)

### Python (pip)
See `docker/pip_requirements.txt`. Key packages include:
- numpy, scipy, matplotlib, pandas, Pillow, h5py, keras_preprocessing, imutils

## Building the Workspace
### Using Docker (Recommended)
1. Build and run the Docker container as above.
2. Inside the container:
   ```bash
   cd /root/kinova_ws
   catkin_make
   source devel/setup.bash
   ```

### Native (Advanced)
- Install ROS Noetic and all dependencies as per `docker/apt_packages.pkg` and `docker/pip_requirements.txt`.
- Clone this repository and build the workspace as above.

## Usage
### Launching the Driver
To bring up the driver for a real robot:
```bash
roslaunch kortex_driver kortex_driver.launch
```

**Key launch arguments:**
- `ip_address`: Robot IP (default: 192.168.1.10)
- `arm`: Model (e.g., gen3, gen3_lite)
- `gripper`: Gripper model (e.g., robotiq_2f_85)
- `robot_name`: Namespace (default: my_<arm>)
- `start_rviz`, `start_moveit`: Visualization and planning

See [kortex_driver/readme.md](kinova_ws/src/ros_kortex/kortex_driver/readme.md) for full details.

### Simulation with Gazebo
To launch a simulated robot in Gazebo:
```bash
roslaunch kortex_gazebo spawn_kortex_robot.launch
```

**Key launch arguments:**
- `arm`, `gripper`, `robot_name`, `start_gazebo`, `start_rviz`, `use_trajectory_controller`

See [kortex_gazebo/readme.md](kinova_ws/src/ros_kortex/kortex_gazebo/readme.md) for more.

### Motion Planning with MoveIt!
MoveIt! is integrated for all supported robot/gripper combinations. Launch with:
```bash
roslaunch kortex_move_it_config <your_config>/launch/move_group.launch
```
Or use the driver/simulation launch files with `start_moveit:=true`.

See [kortex_move_it_config/readme.md](kinova_ws/src/ros_kortex/kortex_move_it_config/readme.md).

### Vision Module
To access the Kinova Vision module:
```bash
roslaunch kinova_vision kinova_vision.launch
```

- Streams color and depth images, point clouds
- Supports calibration and custom camera info

See [ros_kortex_vision/README.md](kinova_ws/src/ros_kortex_vision/README.md) for details.

### Running Examples
A variety of C++ and Python examples are provided:
- Actuator configuration
- Full arm movement
- Cartesian poses
- Vision configuration
- MoveIt! API usage

See [kortex_examples/readme.md](kinova_ws/src/ros_kortex/kortex_examples/readme.md) for usage and launch instructions.

## Customization and Extension
- **URDF/Xacro:** Add or modify robots/grippers in `kortex_description/`
- **Controllers:** Tune PID and control parameters in `kortex_control/`
- **Messages/Services:** Extend or regenerate from protobufs in `kortex_driver/`
- **Simulation Plugins:** Add Gazebo plugins in `third_party/`
- **Vision:** Extend vision nodes or calibration in `ros_kortex_vision/`

## Troubleshooting
- Ensure all dependencies are installed (see Dockerfile and requirements)
- For real hardware, check network connectivity and correct IP address
- For simulation, verify Gazebo and MoveIt! versions
- See package-specific READMEs for detailed troubleshooting

## Licensing and Credits
- Source code is released under the BSD 3-Clause License (see LICENSE files)
- Copyright (c) 2018 Kinova inc.
- Maintainer: Behnam Moradi behnammoradi026@gmail.com

## References
- [Kinova Robotics](https://www.kinovarobotics.com/)
- [ROS Noetic](http://wiki.ros.org/noetic)
- [MoveIt!](https://moveit.ros.org/)
- [Gazebo](http://gazebosim.org/)
- [Kinova ROS Documentation](https://github.com/Kinovarobotics/ros_kortex)

---

For further details, see the README files in each package under `kinova_ws/src/ros_kortex/` and `kinova_ws/src/ros_kortex_vision/`.
