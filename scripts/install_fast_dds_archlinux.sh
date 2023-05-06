#!/bin/bash

export codename=`lsb_release --codename --short`

sudo pacman -Sy
sudo pacman -S unzip git vim openssl gcc make cmake curl tar jdk-openjdk
p11-kit list-modules

openssl engine pkcs11 -t

sudo rm -rf ~/Fast-DDS
sudo rm -rf ~/Fast-DDS-Gen

mkdir ~/Fast-DDS
cd ~/Fast-DDS
CURRENT=`pwd`

sed -i -e '/export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:\/usr\/local\/lib/d' ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' >> ~/.bashrc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# Build boost
cd $CURRENT
if ! [ -f "boost_1_72_0.tar.bz2" ]; then
  curl -L --max-time 1000 --retry 100 --retry-delay 1 https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.bz2 -C - -o "boost_1_72_0.tar.bz2"
fi
if [ $? -eq 0 ]; then
  rm -rf boost_1_72_0 && \
  tar -xf boost_1_72_0.tar.bz2  && \
    cd boost_1_72_0/tools/build && ./bootstrap.sh && \
    mkdir build && \
    ./b2 --prefix=./build install && \
    cd ../../ && \
    ./tools/build/build/bin/b2 cxxstd=17 cxxstd-dialect=gnu abi=aapcs address-model=64 architecture=arm optimization=speed warnings=off threading=multi --without-python --prefix=/usr/local --libdir=/usr/local/lib --includedir=/usr/local/include install
fi

cd $CURRENT
wget https://github.com/leethomason/tinyxml2/archive/refs/tags/9.0.0.tar.gz -O tinyxml2-9.0.0.tar.gz
tar xvf tinyxml2-9.0.0.tar.gz
mkdir tinyxml2-9.0.0/build
cd tinyxml2-9.0.0/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

cd $CURRENT
wget https://yer.dl.sourceforge.net/project/asio/asio/1.28.0%20%28Stable%29/asio-1.28.0.tar.gz -O asio-1.28.0.tar.gz 
tar xvf asio-1.28.0.tar.gz 
cd asio-1.28.0
./configure --prefix=/usr/local/ 
make
sudo make install

https://yer.dl.sourceforge.net/project/asio/asio/1.28.0%20%28Stable%29/asio-1.28.0.tar.gz

cd $CURRENT
wget https://github.com/foonathan/memory/archive/refs/tags/v0.7-2.tar.gz -O memory-0.7-2.tar.gz
tar xvf memory-0.7-2.tar.gz
mkdir memory-0.7-2/build
cd memory-0.7-2/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

cd $CURRENT
wget https://github.com/eProsima/foonathan_memory_vendor/archive/refs/tags/v1.2.1.tar.gz -O foonathan_memory_vendor-1.2.1.tar.gz
tar xvf foonathan_memory_vendor-1.2.1.tar.gz
mkdir foonathan_memory_vendor-1.2.1/build
cd foonathan_memory_vendor-1.2.1/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

cd $CURRENT
wget https://github.com/eProsima/Fast-CDR/archive/refs/tags/v1.0.25.tar.gz -O Fast-CDR-1.0.25.tar.gz
tar xvf Fast-CDR-1.0.25.tar.gz
mkdir Fast-CDR-1.0.25/build
cd Fast-CDR-1.0.25/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

cd $CURRENT
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
git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v2.4.0
cd Fast-DDS-Gen
gradle assemble
cd ..
sudo mv ./Fast-DDS-Gen /opt/fast-dds-gen 

sed -i -e '/export PATH=$PATH:\/opt\/fast-dds-gen\/scripts/d' ~/.bashrc
echo 'export PATH=$PATH:/opt/fast-dds-gen/scripts' >> ~/.bashrc


sudo rm -rf ~/Fast-DDS
sudo rm -rf ~/Fast-DDS-Gen


