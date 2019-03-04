#!/bin/sh
IMAGE_NAME=kapernikov-vo-ts
docker build -t ${IMAGE_NAME} .
docker volume create visual-odometry-volume
