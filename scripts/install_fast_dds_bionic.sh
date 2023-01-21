#!/bin/bash

sudo apt update
sudo apt install -y libasio-dev libtinyxml2-dev libssl-dev libp11-dev libengine-pkcs11-openssl softhsm2 libengine-pkcs11-openssl swig libpython3-dev cmake g++ python3-pip wget git openjdk-8-jdk 

p11-kit list-modules

openssl engine pkcs11 -t

wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ bionic main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
sudo apt update
sudo apt install -y cmake

sudo rm -rf ~/Fast-DDS
sudo rm -rf ~/Fast-DDS-Gen

mkdir ~/Fast-DDS

echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/' >> ~/.bashrc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

cd ~/Fast-DDS
wget https://github.com/foonathan/memory/archive/refs/tags/v0.7-2.tar.gz -O memory-0.7-2.tar.gz
tar xvf memory-0.7-2.tar.gz
mkdir memory-0.7-2/build
cd memory-0.7-2/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON
sudo cmake --build . --target install

cd ~/Fast-DDS
wget https://github.com/eProsima/foonathan_memory_vendor/archive/refs/tags/v1.2.1.tar.gz -O foonathan_memory_vendor-1.2.1.tar.gz
tar xvf foonathan_memory_vendor-1.2.1.tar.gz
mkdir foonathan_memory_vendor-1.2.1/build
cd foonathan_memory_vendor-1.2.1/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON
sudo cmake --build . --target install

cd ~/Fast-DDS
wget https://github.com/eProsima/Fast-CDR/archive/refs/tags/v1.0.25.tar.gz -O Fast-CDR-1.0.25.tar.gz
tar xvf Fast-CDR-1.0.25.tar.gz
mkdir Fast-CDR-1.0.25/build
cd Fast-CDR-1.0.25/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON
sudo cmake --build . --target install

cd ~/Fast-DDS
wget https://github.com/eProsima/Fast-DDS/archive/refs/tags/v2.8.0.tar.gz -O Fast-DDS-2.8.0.tar.gz
tar xvf Fast-DDS-2.8.0.tar.gz
mkdir Fast-DDS-2.8.0/build
cd Fast-DDS-2.8.0/build
sudo cmake ..  -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON
sudo cmake --build . --target install

sudo mkdir /opt/gradle
cd /opt/gradle
sudo wget https://services.gradle.org/distributions/gradle-7.5.1-bin.zip
sudo rm -rf /opt/gradle/gradle-7.5.1
sudo unzip -d /opt/gradle gradle-7.5.1-bin.zip
sudo rm -f gradle-7.5.1-bin.zip

echo 'export PATH=$PATH:/opt/gradle/gradle-7.5.1/bin' >> ~/.bashrc

source ~/.bashrc

export PATH=$PATH:/opt/gradle/gradle-7.5.1/bin

cd ~
git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v2.2.0
cd Fast-DDS-Gen
gradle assemble



