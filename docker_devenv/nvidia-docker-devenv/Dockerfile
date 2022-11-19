FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ARG UID=9001
ARG GID=9001
ARG UNAME=nvidia
ARG HOSTNAME=docker

ARG NEW_HOSTNAME=${HOSTNAME}-Docker

ARG USERNAME=$UNAME
ARG HOME=/home/$USERNAME
RUN useradd -u $UID -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        mkdir /etc/sudoers.d && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        usermod  --uid $UID $USERNAME && \
        groupmod --gid $GID $USERNAME && \
        chown -R $USERNAME:$USERNAME $HOME

# install package
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        sudo \
        less \
        apt-utils \
        tzdata \
        git \
        tmux \
        bash-completion \
        command-not-found \
        libglib2.0-0 \
        vim \
        emacs \
        ssh \
        rsync \
        python3-pip \
        sed \
        ca-certificates \
        wget \
        lsb-release \
        locales

# install package
RUN yes | unminimize && \
    apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        gpg \
        gpg-agent \
        gpgconf \
        gpgv \
        less \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        libgconf-2-4 \
        libgtk-3-0 \
        libnss3 \
        libx11-xcb1 \
        libxss1 \
        libxtst6 \
        net-tools \
        python \
        sshpass \
        chromium-browser \
        qemu-user-static \
        binfmt-support \
        libx11-dev \
        libxrandr-dev \
        libxcursor-dev \
        libxxf86vm-dev \
        libxinerama-dev \
        libxi-dev \
        libglu1-mesa-dev \
        libglew-dev \
        libgles2-mesa-dev \
        nvidia-driver-460 \
        libglfw3 \
        libglfw3-dev \
        software-properties-common \
        gstreamer1.0-plugins-* \
        libgstreamer1.0-* \
        libgstreamer-plugins-*1.0-* \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $USERNAME

# install ROS2 Foxy
RUN sudo curl http://repo.ros2.org/repos.key | sudo apt-key add - && \
    sudo sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu \
    `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
        ros-foxy-desktop \
        && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# install colcon and rosdep
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
        python3-colcon-common-extensions \
        python3-rosdep \
        && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# initialize rosdep
RUN sudo rosdep init && \
    rosdep update

RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc


# set locale
RUN sudo locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

USER root
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/

RUN rm -rf /etc/apt/apt.conf.d/docker-clean