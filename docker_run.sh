#!/bin/sh
xhost + # allow connections to X server
docker run --privileged -e "DISPLAY=unix:0.0" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" -it -e USER=kapernikov kapernikov-vo-ts zsh
