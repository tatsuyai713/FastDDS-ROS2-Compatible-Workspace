#!/bin/bash

cd apps

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

mkdir -p ${CURRENT}/install

cmake ..  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_PREFIX_PATH=$INSTALL_PATH \
  -DCMAKE_PREFIX_PATH=$INSTALL_PATH \
  -Dfastcdr_DIR=$INSTALL_PATH/lib/cmake/fastcdr/ \
  -Dfastrtps_DIR=$INSTALL_PATH/share/fastrtps/cmake/ \
  -DCMAKE_INSTALL_PREFIX=${CURRENT}/install
make -j4


if [ ! $# -ne 1 ]; then
	if [ "install" = $1 ]; then
                sudo make install
	fi
fi
