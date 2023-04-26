#!/bin/bash

rm -r ./build_x86_64
mkdir ./build_x86_64
cd build_x86_64

cmake ..
make -j4
