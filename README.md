# Fast DDS / ROS 2 Compatible Workspace

This repository include Fast DDS build scripts and Fast DDS Sample with ROS 2 compatible topic.

# How to use this repository

1. delete this line from ~/.bashrc

```
source /opt/ros/humble/setup.bash
```

2. Clone from this repository

```
git clone --recursive https://github.com/tatsuyai713/FastDDS-ROS2-Compatible-Workspace.git
```

```
cd FastDDS-ROS2-Compatible-Workspace
```

3. Install Fast DDS on Ubuntu/Debian (and some dds packages)

```
cd scripts
./install_fast_dds_ubuntu_debian.sh
...
...
source ~/.bashrc
```

4. Build and install ROS Compatible libraries (yaml-cpp/ros-data-types/tf2)

```
cd ../fastdds_ws
./build_libraries.sh install
```

5. Build sample apps

```
./build_apps.sh
```

6. Build and install RCL Like Wrapper

```
cd ../rcl_like_wrapper
./build_libraries.sh install
```

7. Build rcl like wrapper sample apps

```
./build_apps.sh
```

Built apps are in apps/build folder.



# Included Open Source

- https://github.com/rticommunity/ros-data-types
- https://github.com/jbeder/yaml-cpp
- https://github.com/eProsima/Fast-DDS

