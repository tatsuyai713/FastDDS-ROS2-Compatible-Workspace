#!/bin/bash

OPT=$1
OPT_NUM=$#

cd apps

# clean
if [ ! $OPT_NUM -ne 1 ]; then
	if [ "clean" = $OPT ]; then
        rm -rf ./build
        rm -rf ./install
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
  -Dfoonathan_memory_DIR=$INSTALL_PATH/lib/foonathan_memory/cmake/ \
  -DCMAKE_INSTALL_PREFIX=${CURRENT}/install
make -j4


if [ ! $OPT_NUM -ne 1 ]; then
	if [ "install" = $OPT ]; then
                make install
	fi
fi
