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

cd build

cmake .. -DCMAKE_INSTALL_PREFIX=${CURRENT}/install
make -j4


if [ ! $# -ne 1 ]; then
	if [ "install" = $1 ]; then
        make install
	fi
fi