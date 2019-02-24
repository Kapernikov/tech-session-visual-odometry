#!/bin/sh
xhost + # allow connections to X server
docker run --name vo --privileged -e "DISPLAY=unix:0.0" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" -itd -e USER=kapernikov kapernikov-vo-ts zsh
