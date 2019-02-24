# tech-session-visual-odometry

Contains code, exercises, docker deployment files for the Visual Odometry Tech Session

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

