#!/bin/bash

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

cmake .. -Dfastcdr_DIR=/usr/local/lib/cmake/fastcdr/ -Dfastrtps_DIR=/usr/local/share/fastrtps/cmake/ -DCMAKE_SYSTEM_PREFIX_PATH=/usr/local/ -DCMAKE_PREFIX_PATH=/usr/local/ -DCMAKE_INSTALL_PREFIX=${CURRENT}/install -DYAML_BUILD_SHARED_LIBS=ON
make -j4


if [ ! $# -ne 1 ]; then
	if [ "install" = $1 ]; then
        make install
	fi
fi
