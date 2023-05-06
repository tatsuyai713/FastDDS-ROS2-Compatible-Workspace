#!/bin/bash

cd libraries
# clean
if [ ! $# -ne 1 ]; then
	if [ "clean" = $1 ]; then
        rm -r ./build
        mkdir ./build
        exit
	fi
fi

CURRENT=`pwd`
mkdir build
cd build

sudo mkdir -p /opt/fast-dds-libs
sudo chmod 777 /opt/fast-dds-libs

cmake .. -Dfastcdr_DIR=/usr/local/lib/cmake/fastcdr/ -Dfastrtps_DIR=/usr/local/share/fastrtps/cmake/ -DCMAKE_SYSTEM_PREFIX_PATH=/usr/local/ -DCMAKE_PREFIX_PATH=/usr/local/ -DCMAKE_INSTALL_PREFIX=/opt/fast-dds-libs -DYAML_BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
make -j4

if [ ! $# -ne 1 ]; then
	if [ "install" = $1 ]; then
                sudo make install
                grep "export LD_LIBRARY_PATH=/opt/fast-dds-libs:$LD_LIBRARY_PATH" ~/.bashrc
                if [ $? = 0 ]; then
                        echo "LD_LIBRARY_PATH libs are already added"
                else
                        echo "export LD_LIBRARY_PATH=/opt/fast-dds-libs:$LD_LIBRARY_PATH" >> ~/.bashrc
                        source ~/.bashrc
                fi
                sudo ldconfig
	fi

fi
