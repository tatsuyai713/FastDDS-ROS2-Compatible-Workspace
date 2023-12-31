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
INSTALL_PATH=/opt/fast-dds
mkdir build
cd build

sudo chmod 777 /opt/fast-dds-libs

cmake ..  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_PREFIX_PATH=$INSTALL_PATH \
  -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -Dfastcdr_DIR=$INSTALL_PATH/lib/cmake/fastcdr/ \
  -Dfastrtps_DIR=$INSTALL_PATH/share/fastrtps/cmake/ \
  -DCMAKE_INSTALL_PREFIX=/opt/fast-dds-libs
make -j4

cd ../yaml-cpp
mkdir build
cd build
cmake ..  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_PREFIX_PATH=$INSTALL_PATH \
  -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -Dfastcdr_DIR=$INSTALL_PATH/lib/cmake/fastcdr/ \
  -Dfastrtps_DIR=$INSTALL_PATH/share/fastrtps/cmake/ \
  -DCMAKE_INSTALL_PREFIX=/opt/fast-dds-libs \
  -DYAML_BUILD_SHARED_LIBS=ON
make -j4

cd $CURRENT/build

if [ ! $# -ne 1 ]; then
	if [ "install" = $1 ]; then
                sudo make install
                cd ../yaml-cpp/build
                sudo make install
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
