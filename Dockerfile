FROM ros:melodic-ros-base-bionic
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -fy sudo wget software-properties-common git apt-utils vim \
  emacs gedit zsh ros-melodic-desktop python-catkin-tools

# create kapernikov user, add to required groups and delete password authentication
RUN useradd -ms /bin/bash kapernikov
RUN usermod -a -G video kapernikov
RUN usermod -a -G sudo kapernikov
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# setup environment
USER kapernikov
ENV TERM xterm
RUN wget -q https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
RUN git clone -q --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN git clone -q --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git ~/.oh-my-zsh/plugins/zsh-history-substring-search
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/.zshrc -O ~/.zshrc
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/my.zsh-theme -O ~/.oh-my-zsh/themes/my_zsh_theme.zsh-theme
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/.aliases -O ~/.aliases
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/.bash_scripts -O ~/.bash_scripts

# setup ros environment
USER kapernikov
RUN mkdir -p /home/kapernikov/catkin_ws/src
RUN rosdep update
USER root
ADD --chown=kapernikov:kapernikov . / /home/kapernikov/catkin_ws/src/tech-session-visual-odometry/
RUN DEBIAN_FRONTEND=noninteractive rosdep install -yr --from-paths /home/kapernikov/catkin_ws/src --ignore-src --rosdistro melodic
USER kapernikov
WORKDIR /home/kapernikov/catkin_ws
RUN catkin config --extend /opt/ros/melodic
RUN catkin build
RUN rm -rf /home/kapernikov/src/tech-session-visual-odometry
RUN ln -sf /home/kapernikov/catkin_ws/src/tech-session-visual-odometry/datasets /home/kapernikov/.ros/datasets
RUN ln -sf /home/kapernikov/catkin_ws/src/tech-session-visual-odometry/stereo_calibration /home/kapernikov/.ros/stereo_calibration
WORKDIR /home/kapernikov

# COMMENT OUT below commands for minimum installation
# Install opencv - Get access to opencv features SIFT, SURF etc
# --------------
# USER root
# RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
# RUN apt-get -y install build-essential cmake libgtk2.0-dev pkg-config libavcodec-dev \
  # libavformat-dev libswscale-dev python-dev python-numpy libtbb2 libtbb-dev \
  # libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev checkinstall yasm \
  # gfortran libjpeg8-dev libjasper-dev software-properties-common libjasper1 \
  # libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
  # libxine2-dev libv4l-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  # libgtk2.0-dev libtbb-dev qt5-default libatlas-base-dev libfaac-dev \
  # libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev \
  # libopencore-amrnb-dev libopencore-amrwb-dev libavresample-dev x264 v4l-utils \
  # python3-testresources python3-dev python3-pip python3-dev \
  # libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev \
  # libgphoto2-dev libeigen3-dev libhdf5-dev doxygen python-numpy python-pip
# RUN cd /usr/include/linux && ln -s -f ../libv4l1-videodev.h videodev.h && cd -
# USER kapernikov
# RUN git clone -q -b 3.4.5 --depth=1 https://github.com/opencv/opencv.git /home/kapernikov/opencv
# RUN git clone -q -b 3.4.5 --depth=1 https://github.com/opencv/opencv_contrib.git /home/kapernikov/opencv_contrib
# WORKDIR /home/kapernikov/opencv
# RUN mkdir build
# WORKDIR build
# RUN cmake .. \
  # -DCMAKE_BUILD_TYPE=RELEASE \
  # -DCMAKE_INSTALL_PREFIX=/usr/local \
  # -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
  # -DOPENCV_ENABLE_NONFREE=ON \
  # -DWITH_QT=ON \
  # -DWITH_OPENGL=ON
# RUN make -j4
# USER root
# RUN make -j4 install
# RUN git clone -q --depth=1 https://github.com/ros-perception/vision_opencv.git ~/catkin_ws/src/vision_opencv
# WORKDIR /home/kapernikov/catkin_ws
# RUN catkin build vision_opencv

# Install rtabmap from source - for access to different feature types, vo, graph optimization algorithms
# ---------------------------
# install g2o
# USER root
# RUN apt-get -y install libsqlite3-dev libpcl-dev libopencv-dev git cmake libproj-dev libqt5svg5-dev
# USER kapernikov
# RUN git clone -q --depth=1  https://github.com/RainerKuemmerle/g2o.git ~/g2o
# WORKDIR ~/g2o
# RUN mkdir build
# WORKDIR build
# RUN cmake -DBUILD_WITH_MARCH_NATIVE=OFF -DG2O_BUILD_APPS=OFF -DG2O_BUILD_EXAMPLES=OFF -DG2O_USE_OPENGL=OFF ..
# RUN make -j4
# USER root
# RUN make -j4 install

#install GTSAM
# user kapernikov
# RUN clone --branch 4.0.0-alpha2 https://github.com/borglab/gtsam.git gtsam-4.0.0-alpha2 ~/gtsam
# WORKDIR ~/gtsam
# RUN mkdir build
# WORKDIR build
# RUN cmake -DGTSAM_USE_SYSTEM_EIGEN=ON -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF -DGTSAM_BUILD_TESTS=OFF -DGTSAM_BUILD_UNSTABLE=OFF ..
# RUN make -j4
# USER root
# RUN make -j4 install

# install rtabmap
# USER kapernikov
# RUN git clone -q --depth=1 https://github.com/introlab/rtabmap.git ~/rtabmap
# WORKDIR ~/rtabmap/build
# RUN cmake .. && make -j4
# USER root
# RUN make -j4 install
# RUN ldconfig

# install rtabmap-ros
# USER kapernikov
# RUN git clone -q --depth=1 https://github.com/introlab/rtabmap_ros.git ~/catkin_ws/src/rtabmap_ros
# RUN git clone -q --depth=1 https://github.com/ros-perception/vision_opencv.git
# WORKDIR ~/catkin_ws
# RUN catkin build

# set default directory
WORKDIR /home/kapernikov
