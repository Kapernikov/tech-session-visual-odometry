#!/bin/sh
xhost + # allow connections to X server
docker start visual-odometry -a > /dev/null 2>&1 || \
docker run \
    --name="visual-odometry" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env USER=kapernikov \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$PWD:/home/kapernikov/catkin_ws/src/tech-session-visual-odometry" \
    -itd kapernikov-vo-ts zsh
