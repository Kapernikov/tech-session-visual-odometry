#!/bin/sh
xhost + # allow connections to X server
docker start visual-odometry || \
docker run \
    --name="visual-odometry" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env USER=kapernikov \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="visual-odometry-volume:/home:rw" \
    -itd kapernikov-vo-ts zsh
