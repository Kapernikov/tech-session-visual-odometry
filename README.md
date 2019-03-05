# tech-session-visual-odometry

Contains code and docker deployment files for the Visual Odometry Tech Session

## Contents
- [Environment Installation](#environment-installation)
  - [Native-Ubuntu](#native-ubuntu)
  - [Docker](#docker)
  - [Virtual Machine](#virtual-machine)
- [Extras](#extras)
  - [OpenCV Installation](#opencv-installation)
  - [RTAB-Map Installation](#rtab-map-installation)


## Environment Installation
By following this guide, you can create a working environment for experimentation
with visual odometry and visual slam. There are three different ways this can
be accomplished.
- The first one, involves installing ros, this package and all required
dependencies natively in an Ubuntu 18.04 OS.
- The second option is to install a specially prepared docker container that
will work in a Linux host OS, but there may be issues with exported graphics in
a Windows host OS.
- The third and final option is to install a virtual machine image containing an
Ubuntu 18.04 OS with all required libraries.

Installation via Docker or Virtual Machine has the disadvantage of slower
execution of the gazebo robot simulator and possible of the visual odometry/slam
algorithms due to reduced frame rate and update frequency.

Recommendation:
- Native installation for Ubuntu users
- Docker installation for non-Ubuntu-Linux users
- Virtual machine installation for Windows users

### Native-Ubuntu
- Install [ROS Melodic Morenia](http://wiki.ros.org/melodic/Installation/Ubuntu)
- Install catkin tools
```bash
$ sudo apt -y install python-catkin-tools
```
- Initialize the ROS workspace
```bash
$ mkdir -p ~/catkin_ws/src
$ cd ~/catkin_ws && catkin init
```
- Clone this repository:
```bash
$ git clone https://gitlab.com/Kapernikov/Intern/tech-session-visual-odometry.git ~/catkin_ws/src/tech-session-visual-odometry.git
```
- Install dependencies
```bash
$ cd ~/catkin_ws && rosdep install -yr --from-paths src --ignore-src --rosdistro melodic
```
- Build the workspace
```bash
$ catkin build
```

### Docker
- Install docker for [Windows](https://docs.docker.com/docker-for-windows/install/) or [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- Clone this repository:
```bash
$ git clone https://gitlab.com/Kapernikov/Intern/tech-session-visual-odometry.git
```
- Build the image:
```bash
$ cd /path/to/tech-session-visual-odometry
$ ./docker_build.sh
```
- Create the container from the built image:
```bash
$ ./docker_run.sh
```
- Connect a terminal to the running container
```bash
$ ./docker_connect.sh
```

### Virtual Machine
- Download and install Virtual-Box 5.2 (NOT 6.0) from the [official website](www.virtualbox.org/wiki/Download_Old_Builds_5_2)
- Get the VM image in OVF format (will be passed around in a USB flash drive)
- Open Virtual Box 5.2
- Go to File > Import Appliance and browse to find the VM image
- In the next screen you can change settings such as allocated CPU or RAM.
Opt for at least half of your system total. For example if you have 8 cores and
16GB RAM allocate 4 cores and 8GB RAM to the VM.
- After finishing the import process, select the VM in the VBox manager and
start it
- Log in to user: kapernikov with password: kapernikov

## Extras
**This step is optional and applicable for the more advanced exercises.**

Installing OpenCV (3.4.5) with opencv-contrib will include xfeatures2d (and
cuda) enabling the use of different features (eg. SIFT, SURF etc) in RTAB-Map.
RTAB-Map and RTAB-Map ROS must be installed from source in order to access these
features. Furthermore, before building RTAB-Map and RTAB-Map ROS from source,
you can install other 3rd party visual odometry and visual slam libraries
(eg. viso2, orb2-slam etc) and then RTAB-Map will be able to be built with those
libraries and run with different visual odometry or vslam algorithms other than
the default F2M and F2F.

### OpenCV Installation
**Warning: Takes a long time! Prepare in advance!**

- Install dependencies
```bash
$ sudo apt-get install
  build-essential \
  cmake \
  git \
  libgtk2.0-dev \
  pkg-config \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  python-dev \
  python-numpy \
  libtbb2 \
  libtbb-dev \
  libjpeg-dev \
  libpng-dev \
  libtiff-dev \
  libjasper-dev \
  libdc1394-22-dev
```
- Clone the repositories:
```bash
$ git clone -b 3.4.5 https://github.com/opencv/opencv.git ~/opencv
$ git clone -b 3.4.5 https://github.com/opencv/opencv_contrib.git ~/opencv_contrib
```

- Build OpenCV without CUDA
```bash
$ cd opencv && mkdir build && cd build
$ cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -DWITH_NONFREE=ON
$ make -j4
$ sudo make install
```

- Build OpenCV with CUDA
```bash
$ cd opencv && mkdir build && cd build
$ cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=ON \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -DBUILD_opencv_cudacodec=OFF \
    -DWITH_NVCUVID=OFF \
    -DWITH_NONFREE=ON
$ make -j4
$ sudo make install
```

### RTAB-Map installation
**Warning: Takes a long time! Prepare in advance!**

- Install dependencies (g2o, GTSAM) by following the instructions in the [official installation page](https://github.com/introlab/rtabmap/wiki/Installation)
- Clone the repositories
```bash
$ git clone https://github.com/introlab/rtabmap.git ~/rtabmap
$ git clone https://github.com/introlab/rtabmap_ros.git ~/catkin_ws/src/rtabmap_ros
```
- (Optional) Build another visual odometry or vslam library that integrates with rtabmap such as
libfovis, libviso2, dvo_core, okvis, msckf_vio, ORB_SLAM2. For example we will install libviso2:
```bash
$ git clone git@github.com:srv/viso2.git ~/viso2
$ cd ~/viso2/libviso2 && mkdir build && cd build
$ cmake ..
$ make -j4
$ sudo make install
```
- Build RTAB-Map
```bash
$ cd ~/rtabmap
$ mkdir build && cd build
$ cmake ..
$ make -j4
$ sudo make install
```
When executing the cmake you will see the libraries that are installed and will be integrated with
RTAB-Map.

- Build RTAB-Map ROS
```bash
$ cd ~/catkin_ws
$ catkin build rtabmap_ros
```
