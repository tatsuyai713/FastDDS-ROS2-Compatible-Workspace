#!/bin/bash


sudo rm ./opencv_build -rf
mkdir opencv_build
cd opencv_build

CURRENT=`pwd`


cd $CURRENT
wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.7.0.tar.gz -O yaml-cpp-0.7.0.tar.gz
tar xvf yaml-cpp-0.7.0.tar.gz
mkdir yaml-cpp-yaml-cpp-0.7.0/build
cd yaml-cpp-yaml-cpp-0.7.0/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/ -DYAML_BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE="Release"
sudo cmake --build . --target install

# Install OpenCV
cd $CURRENT
OPENCV_VERSION=4.3.0
git clone --depth 1 -b ${OPENCV_VERSION} https://github.com/opencv/opencv.git opencv-${OPENCV_VERSION} \
    && cd opencv-${OPENCV_VERSION} && \
    mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release \
             -DPYTHON3_EXECUTABLE=/usr/bin/python3 \
             -DVIBRANTE_PDK:STRING=/ \
             -DCMAKE_INSTALL_PREFIX=/usr/local \
             -DBUILD_SHARED_LIBS=ON \
             -DBUILD_LIST=core,improc,imgcodecs,flann,highgui,calib3d,features2d,objdetect,photo,video,dnn,ml,gapi \
             -DBUILD_PNG=ON \
             -DBUILD_TBB=OFF \
             -DBUILD_WEBP=OFF \
             -DBUILD_JPEG=ON \
             -DBUILD_TIFF=ON \
             -DWITH_JPEG=ON \
             -DWITH_TIFF=ON \
             -DBUILD_JASPER=OFF \
             -DBUILD_ZLIB=ON \
             -DBUILD_EXAMPLES=OFF \
             -DBUILD_FFMPEG=ON \
             -DBUILD_opencv_java=OFF \
             -DBUILD_opencv_python2=OFF \
             -DBUILD_opencv_python3=OFF \
             -DBUILD_opencv_stitching=OFF \
             -DBUILD_opencv_dnn=OFF \
             -DENABLE_NEON=OFF \
             -DWITH_PROTOBUF=OFF \
             -DWITH_PTHREADS_PF=ON \
             -DWITH_OPENCL=OFF \
             -DWITH_OPENMP=OFF \
             -DWITH_FFMPEG=OFF \
             -DWITH_GSTREAMER=OFF \
             -DWITH_GSTREAMER_0_10=OFF \
             -DWITH_CUDA=OFF \
             -DWITH_GTK=OFF \
             -DWITH_VTK=OFF \
             -DWITH_TBB=OFF \
             -DWITH_1394=OFF \
             -DWITH_OPENEXR=OFF \
             -DINSTALL_C_EXAMPLES=OFF \
             -DINSTALL_TESTS=OFF \
             -DVIBRANTE=TRUE \
             VERBOSE=1 ../ \
    && sudo make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install 


