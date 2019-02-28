# tech-session-visual-odometry

Contains code and docker deployment files for the Visual Odometry Tech Session

## Installation
### Using Docker
- Install docker for [Windows](https://docs.docker.com/docker-for-windows/install/) or [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- Clone this repository:
```bash
$ git clone https://gitlab.com/Kapernikov/Intern/tech-session-visual-odometry.git
```
- Build the image:
```bash
$ cd /path/to/ptech-session-visual-odometry
$ ./docker_build.sh
```
- Create the container:
```bash
$ ./docker_run.sh
```

### Manual Installation
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

### (Optional) Install OpenCV and RTAB-Map from source - For the more advanced exercises
Installing OpenCV (3.4.5) with opencv-contrib will include xfeatures2d (and cuda) enabling the use of different features (eg. SIFT, SURF etc)
in RTAB-Map. RTAB-Map and RTAB-Map ROS must be installed from source in order to access these features. Furthermore, before building RTAB-Map
and RTAB-Map ROS from source, you can install other 3rd party visual odometry and visual slam libraries (eg. viso2, orb2-slam etc)
and then RTAB-Map will be able to be built with those libraries and run with different visual odometry or vslam algorithms other than
the default F2M and F2F.

(the next steps can also be done inside a docker container)

#### OpenCV Installation (Warning: May take hours!!!)
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
- Build OpenCV  
(delete the WITH\_CUDA, ENABLE_FAST\_MATH, CUDA\_FAST\_MATH WITH\_CUBLAS lines if you don't have cuda installed)
```bash
$ cd opencv && mkdir build && cd build
$ cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_CUDA=ON \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON .. \
    -DBUILD_opencv_cudacodec=OFF \
    -DWITH_NVCUVID=OFF \
    -DWITH_NONFREE=ON
$ make -j4
$ sudo make install
```

#### RTAB-Map installation
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
