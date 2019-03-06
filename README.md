# tech-session-visual-odometry

Contains code and docker deployment files for the Visual Odometry Tech Session

## Contents
- [Environment Installation](#environment-installation)
  - [Native-Linux](#native-Linux)
  - [Docker](#docker)
  - [Virtual Machine](#virtual-machine)
- [Extras](#extras)
  - [OpenCV Installation](#opencv-installation)
  - [RTAB-Map Installation](#rtab-map-installation)


## Environment Installation
By following this guide, you can create a working environment for experimentation
with visual odometry and visual slam. There are three different ways this can
be accomplished.
- The first option is to install ros, this package and all required libraries
natively in an Ubuntu 18.04 OS or Debian Stretch. There is also experimental
support for Arch Linux.
- The second option is to install a specially prepared docker container that
will work in a Linux host OS, but there may be issues with exported graphics in
a Windows host OS.
- The third and final option is to install a virtual machine image containing an
Ubuntu 18.04 OS with all required libraries.

*Warning: Installation via Docker or Virtual Machine has the disadvantage of slower
execution of the gazebo robot simulator and possible of the visual odometry/slam
algorithms due to reduced frame rate and update frequency.*

Recommendation:
- Native installation for Ubuntu/Debian/Arch Linux users
- Docker installation for non-Ubuntu/Debian/Arch Linux users
- Virtual machine installation for Windows users

### Native-Linux
Supported Operating Systems: Ubuntu, Debian and possibly Arch Linux
- Install [ROS Melodic Morenia](http://wiki.ros.org/melodic/Installation)
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
- Download the [Virtual Machine image](https://drive.google.com/file/d/1qs0CiKUQjco2b_ETcRCl7dWXmvT38N1K/view?usp=sharing).
It will alo be passed around in USB flash drive on the day of the tech session.
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
$ sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
$ sudo apt-get -y install build-essential cmake libgtk2.0-dev pkg-config libavcodec-dev \
  libavformat-dev libswscale-dev python-dev python-numpy libtbb2 libtbb-dev \
  libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev checkinstall yasm \
  gfortran libjpeg8-dev libjasper-dev software-properties-common libjasper1 \
  libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
  libxine2-dev libv4l-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  libgtk2.0-dev libtbb-dev qt5-default libatlas-base-dev libfaac-dev \
  libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev \
  libopencore-amrnb-dev libopencore-amrwb-dev libavresample-dev x264 v4l-utils \
  python3-testresources python3-dev python3-pip python-pip pytho-dev \
  libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev \
  libgphoto2-dev libeigen3-dev libhdf5-dev doxygen python-numpy python3-numpy

$ cd /usr/include/linux && sudo ln -s -f ../libv4l1-videodev.h videodev.h && cd -
```
- Clone the repositories:
```bash
$ git clone -b 3.4.5 https://github.com/opencv/opencv.git ~/opencv
$ git clone -b 3.4.5 https://github.com/opencv/opencv_contrib.git ~/opencv_contrib
```

- Build OpenCV without CUDA
```bash
$ cd opencv && mkdir build && cd build
$ cmake .. \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -DWITH_ENABLE_NONFREE=ON \
    -DWITH_QT=ON \
    -DWITH_OPENGL=ON
$ make -j4
$ sudo make install
```

- Build OpenCV with CUDA
```bash
$ cd opencv && mkdir build && cd build
$ cmake .. -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=ON \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -DBUILD_opencv_cudacodec=OFF \
    -DWITH_NVCUVID=OFF \
    -DWITH_ENABLE_NONFREE=ON \
    -DWITH_QT=ON \
    -DWITH_OPENGL=ON
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
