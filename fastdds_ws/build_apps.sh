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
mkdir build
cd build

mkdir -p ${CURRENT}/install

cmake .. -Dfastcdr_DIR=/usr/local/lib/cmake/fastcdr/ -Dfastrtps_DIR=/usr/local/share/fastrtps/cmake/ -DCMAKE_SYSTEM_PREFIX_PATH=/opt/fast-dds-libs/ -DCMAKE_PREFIX_PATH=/opt/fast-dds-libs/ -DCMAKE_INSTALL_PREFIX=${CURRENT}/install -DYAML_BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
make -j4


if [ ! $# -ne 1 ]; then
	if [ "install" = $1 ]; then
                sudo make install
	fi
fi
