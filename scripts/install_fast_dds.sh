#!/bin/bash

CURRENT=`pwd`

export codename=`lsb_release --codename --short`

sudo apt update
sudo apt install -y libasio-dev libtinyxml2-dev libssl-dev libp11-dev libengine-pkcs11-openssl softhsm2 libengine-pkcs11-openssl swig libpython3-dev g++ python3-pip wget git openjdk-8-jdk 
p11-kit list-modules

openssl engine pkcs11 -t

sudo rm -rf ~/Fast-DDS
sudo rm -rf ~/Fast-DDS-Gen

sudo mv /opt/ros/ /opt/ros_tmp/

mkdir ~/Fast-DDS

sed -i -e '/export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:\/usr\/local\/lib/d' ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' >> ~/.bashrc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

cd ~/Fast-DDS
wget https://github.com/foonathan/memory/archive/refs/tags/v0.7-2.tar.gz -O memory-0.7-2.tar.gz
tar xvf memory-0.7-2.tar.gz
mkdir memory-0.7-2/build
cd memory-0.7-2/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install


cd ~/Fast-DDS
wget https://github.com/eProsima/foonathan_memory_vendor/archive/refs/tags/v1.2.1.tar.gz -O foonathan_memory_vendor-1.2.1.tar.gz
tar xvf foonathan_memory_vendor-1.2.1.tar.gz
mkdir foonathan_memory_vendor-1.2.1/build
cd foonathan_memory_vendor-1.2.1/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

cd ~/Fast-DDS
wget https://github.com/eProsima/Fast-CDR/archive/refs/tags/v1.0.25.tar.gz -O Fast-CDR-1.0.25.tar.gz
tar xvf Fast-CDR-1.0.25.tar.gz
mkdir Fast-CDR-1.0.25/build
cd Fast-CDR-1.0.25/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

cd ~/Fast-DDS
wget https://github.com/eProsima/Fast-DDS/archive/refs/tags/v2.8.2.tar.gz -O Fast-DDS-2.8.2.tar.gz
tar xvf Fast-DDS-2.8.2.tar.gz
mkdir Fast-DDS-2.8.2/build
cd Fast-DDS-2.8.2/build
sudo cmake .. -Dfastcdr_DIR=/usr/local/lib/cmake/fastcdr/ -Dfoonathan_memory_DIR=/usr/local/lib/foonathan_memory/cmake/ -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

sudo mkdir /opt/gradle
cd /opt/gradle
sudo wget https://services.gradle.org/distributions/gradle-7.5.1-bin.zip
sudo rm -rf /opt/gradle/gradle-7.5.1
sudo unzip -d /opt/gradle gradle-7.5.1-bin.zip
sudo rm -f gradle-7.5.1-bin.zip

sed -i -e '/export PATH=$PATH:\/opt\/gradle\/gradle-7.5.1\/bin/d' ~/.bashrc
echo 'export PATH=$PATH:/opt/gradle/gradle-7.5.1/bin' >> ~/.bashrc

source ~/.bashrc

export PATH=$PATH:/opt/gradle/gradle-7.5.1/bin

cd ~
git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v2.2.0
cd Fast-DDS-Gen
gradle assemble
cd ..
sudo mv ./Fast-DDS-Gen /opt/fast-dds-gen 

sed -i -e '/export PATH=$PATH:\/opt\/fast-dds-gen\/scripts/d' ~/.bashrc
echo 'export PATH=$PATH:/opt/fast-dds-gen/scripts' >> ~/.bashrc


sudo rm -rf ~/Fast-DDS
sudo rm -rf ~/Fast-DDS-Gen

sudo mv /opt/ros_tmp/ /opt/ros/
