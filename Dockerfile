FROM ros:melodic-ros-base-bionic
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y sudo wget software-properties-common apt-utils vim emacs gedit zsh

# create kapernikov user, add to required groups and delete password authentication
RUN useradd -ms /bin/bash kapernikov
RUN usermod -a -G video kapernikov
RUN usermod -a -G sudo kapernikov
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# setup environment
USER kapernikov
ENV TERM xterm
RUN wget -q https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone -q https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
RUN git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN git clone -q https://github.com/zsh-users/zsh-history-substring-search.git ~/.oh-my-zsh/plugins/zsh-history-substring-search
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/.zshrc -O ~/.zshrc
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/my.zsh-theme -O ~/.oh-my-zsh/themes/my_zsh_theme.zsh-theme
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/.aliases -O ~/.aliases
RUN wget -q https://raw.githubusercontent.com/gkouros/dotfiles/master/.bash_scripts -O ~/.bash_scripts


# setup ros environment
USER root
RUN apt-get -y install python-catkin-tools
USER kapernikov
RUN mkdir -p /home/kapernikov/catkin_ws/src/visual-odometry-tech-session
ADD --chown=kapernikov:kapernikov . / /home/kapernikov/catkin_ws/src/visual-odometry-tech-session/
RUN rosdep update
USER root
RUN DEBIAN_FRONTEND=noninteractive rosdep install -yr --from-paths /home/kapernikov/catkin_ws/src --ignore-src --rosdistro melodic
# RUN rm -rf /var/lib/apt/lists
USER kapernikov
WORKDIR /home/kapernikov/catkin_ws
RUN catkin config --extend /opt/ros/melodic
RUN catkin build
WORKDIR /home/kapernikov
