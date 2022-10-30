#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)


NAME_IMAGE='nvidia_egl_desktop_devenv_ws'

# Make Container
if [ ! "$(docker image ls -q ${NAME_IMAGE})" ]; then
	if [ ! $# -ne 1 ]; then
		if [ "setup" = $1 ]; then
			echo "Image ${NAME_IMAGE} does not exist."
			echo 'Now building image without proxy...'
			docker build --file=./nvidia-egl-desktop-ros2/foxy/Dockerfile -t $NAME_IMAGE . --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg UNAME=$USER
		fi
	else
		echo "Docker image not found. Please setup first!"
		exit
  	fi
fi

# Commit
if [ ! $# -ne 1 ]; then
	if [ "commit" = $1 ]; then
		echo 'Now commiting docker container...'
		docker commit nvidia_egl_desktop_devenv_docker nvidia_egl_desktop_devenv_ws:latest
		CONTAINER_ID=$(docker ps -a | grep nvidia_egl_desktop_devenv_docker | awk '{print $1}')
		docker stop $CONTAINER_ID
		docker rm $CONTAINER_ID
		exit
	fi
fi

XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
if [ ! -z "$xauth_list" ];  then
  echo $xauth_list | xauth -f $XAUTH nmerge -
fi
chmod a+r $XAUTH

DOCKER_OPT=""
DOCKER_NAME="nvidia_egl_desktop_devenv_docker"
DOCKER_WORK_DIR="/home/${USER}"

## For XWindow
DOCKER_OPT="${DOCKER_OPT} \
        --env=QT_X11_NO_MITSHM=1 \
        --volume=/home/${USER}:/home/${USER}/host_home:rw \
        --env=XAUTHORITY=${XAUTH} \
        --volume=${XAUTH}:${XAUTH} \
        --env=DISPLAY=${DISPLAY} \
		--shm-size=1024m \
		-e SIZEW=1920 \
		-e SIZEH=1080 \
		-e PASSWD=mypasswd \
		-e BASIC_AUTH_PASSWORD=mypasswd \
		-e NOVNC_ENABLE=true \
		-p 6080:8080 
        -w ${DOCKER_WORK_DIR} \
        -u ${USER} \
        --hostname `hostname`-Docker \
        --add-host `hostname`-Docker:127.0.1.1"

DOCKER_OPT="${DOCKER_OPT} --privileged -it "

# Device
if [ ! $# -ne 1 ]; then
	if [ "device" = $1 ]; then
		echo 'Enable host devices'
		DOCKER_OPT="${DOCKER_OPT} --volume=/dev:/dev:rw "
	fi
fi

## Allow X11 Connection
xhost +local:`hostname`-Docker
CONTAINER_ID=$(docker ps -a | grep nvidia_egl_desktop_devenv_ws: | awk '{print $1}')

# Run Container
if [ ! "$CONTAINER_ID" ]; then
	if [ ! $# -ne 1 ]; then
		if [ "setup" = $1 ]; then
			docker run ${DOCKER_OPT} \
				--env=TERM=xterm-256color \
				--name=${DOCKER_NAME} \
				--entrypoint "/usr/bin/supervisord" \
				nvidia_egl_desktop_devenv_ws:latest
		else
			docker run ${DOCKER_OPT} \
				--env=TERM=xterm-256color \
				--name=${DOCKER_NAME} \
				--entrypoint "bash" \
				nvidia_egl_desktop_devenv_ws:latest
		fi
	else
		docker run ${DOCKER_OPT} \
			--env=TERM=xterm-256color \
			--name=${DOCKER_NAME} \
			--entrypoint "bash" \
			nvidia_egl_desktop_devenv_ws:latest
	fi
else
	docker start $CONTAINER_ID
	docker exec -it $CONTAINER_ID /bin/bash
fi

xhost -local:`hostname`-Docker

