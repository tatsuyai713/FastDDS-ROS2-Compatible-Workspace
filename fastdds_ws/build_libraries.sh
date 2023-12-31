#!/bin/bash

OPT=$1
OPT_NUM=$#

cd libraries
# clean
if [ ! $OPT_NUM -ne 1 ]; then
	if [ "clean" = $OPT ]; then
        rm -rf ./build
        mkdir ./build
        exit
	fi
fi

CURRENT=`pwd`
INSTALL_PATH=/opt/fast-dds
mkdir build
cd build

sudo mkdir -p /opt/fast-dds-libs
sudo chmod 777 /opt/fast-dds-libs

cmake ..  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_PREFIX_PATH=$INSTALL_PATH \
  -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -Dfastcdr_DIR=$INSTALL_PATH/lib/cmake/fastcdr/ \
  -Dfastrtps_DIR=$INSTALL_PATH/share/fastrtps/cmake/ \
  -Dfoonathan_memory_DIR=$INSTALL_PATH/lib/foonathan_memory/cmake/ \
  -DCMAKE_INSTALL_PREFIX=/opt/fast-dds-libs \
  -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -DYAML_BUILD_SHARED_LIBS=ON
make -j4

cd $CURRENT/build

if [ ! $OPT_NUM -ne 1 ]; then
	if [ "install" = $OPT ]; then
                make install
                grep 'export LD_LIBRARY_PATH=/opt/fast-dds-libs/lib:$LD_LIBRARY_PATH' ~/.bashrc
                if [ $? = 0 ]; then
                        echo "LD_LIBRARY_PATH libs are already added"
                else
                        echo 'export LD_LIBRARY_PATH=/opt/fast-dds-libs/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
                        source ~/.bashrc
                fi
                sudo ldconfig
	fi

fi
