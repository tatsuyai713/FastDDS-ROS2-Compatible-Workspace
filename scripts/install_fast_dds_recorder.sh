#!/bin/bash

CURRENT=`pwd`

sudo apt install -y qtbase5-dev liblz4-dev libzstd-dev libyaml-cpp-dev

sudo mv /opt/ros/ /opt/ros_tmp/

rm -rf ./fastdds_dev_utils
rm -rf ./fastdds_pipe
rm -rf ./fastdds_recorder

mkdir fastdds_dev_utils
cd fastdds_dev_utils
wget https://github.com/eProsima/dev-utils/archive/refs/tags/v0.3.0.tar.gz
tar xvf v0.3.0.tar.gz
cd dev-utils-0.3.0
cd cmake_utils
mkdir build
cd build
cmake ..
make
sudo make install
cd ../../

cd cpp_utils
mkdir build
cd build
cmake ..
make
sudo make install

cd $CURRENT

mkdir fastdds_pipe
cd fastdds_pipe
wget https://github.com/eProsima/DDS-Pipe/archive/refs/tags/v0.1.0.tar.gz

tar xvf v0.1.0.tar.gz

cd DDS-Pipe-0.1.0

cd ddspipe_core
mkdir build
cd build
cmake ..
make
sudo make install
cd ../../

cd ddspipe_participants
mkdir build
cd build
cmake ..
make
sudo make install
cd ../../

cd ddspipe_yaml
mkdir build
cd build
cmake ..
make
sudo make install

cd $CURRENT

mkdir fastdds_recorder
cd fastdds_recorder
wget https://github.com/eProsima/DDS-Recorder/archive/refs/tags/v0.1.0.tar.gz
tar xvf v0.1.0.tar.gz
cd DDS-Record-Replay-0.1.0

cd ddsrecorder_participants
mkdir build
cd build
cmake ..
make
sudo make install
cd ../../

cd controller/controller_tool
mkdir build
cd build
cmake ..
make
cd ../../../

cd ddsrecorder_yaml
mkdir build
cd build
cmake ..
make
sudo make install
cd ../../

cd ddsrecorder
mkdir build
cd build
cmake .. -Dfastcdr_DIR=/usr/local/lib/cmake/fastcdr/ -Dfoonathan_memory_DIR=/usr/local/lib/foonathan_memory/cmake/ -Dfastrtps_DIR=/usr/local/share/fastrtps/cmake/
make
sudo make install

cd $CURRENT

rm -rf ./fastdds_dev_utils
rm -rf ./fastdds_pipe
rm -rf ./fastdds_recorder

sudo mv /opt/ros_tmp/ /opt/ros/

