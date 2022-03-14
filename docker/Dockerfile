ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

ENV CI_BUILD_PYTHON python
ENV LANG C.UTF-8
ARG CACHE_STOP=1
ARG CHECKOUT_TF_SRC=0
ARG BAZEL_VERSION=3.7.2

# Setup ROS networking
ARG ROS_MASTER_URI=http://localhost:11311
ARG ROS_IP=localhost
ARG ROS_HOSTNAME=localhost


# Install apt packages
COPY apt_packages.pkg /tmp/apt_packages.pkg
RUN apt-get update && \
    apt-get install -y \
        $(cat /tmp/apt_packages.pkg) \
    && rm -rf /var/lib/apt/lists/* /tmp/apt.pkg

RUN ln -s $(which python3) /usr/local/bin/python

# Install PIP Packages
ADD pip_requirements.txt /tmp/pip_requirements.txt
RUN python3 -m pip install --upgrade pip &&\
    python3 -m pip --no-cache-dir install -r /tmp/pip_requirements.txt

RUN mkdir /bazel && \
    wget -O /bazel/installer.sh "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh" && \
    wget -O /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x /bazel/installer.sh && \
    /bazel/installer.sh && \
    rm -f /bazel/installer.sh

# Install TFOD
RUN chmod a+w /etc/passwd /etc/group
RUN test "${CHECKOUT_TF_SRC}" -eq 1 && git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src || true
# RUN git clone https://github.com/tensorflow/models.git
# RUN (cd models/research && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py --force-reinstall && protoc object_detection/protos/*.proto --python_out=. && cp object_detection/packages/tf2/setup.py . && python3 -m pip install --use-feature=2020-resolver .)

# Installing ROS-Noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

RUN apt-get update && apt-get install -y \
    ros-noetic-desktop-full \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential \
    ros-noetic-ros-numpy \
    ros-noetic-tf2-sensor-msgs \
    python3-colcon-common-extensions \
    ros-noetic-vision-msgs \
    bash-completion

RUN rosdep init
RUN rosdep update

# RUN cd /opt/models
RUN (cd /opt/ && git clone https://github.com/tensorflow/models.git && cd /opt/models/research && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py --force-reinstall && protoc object_detection/protos/*.proto --python_out=. && cp object_detection/packages/tf2/setup.py . && python3 -m pip install --use-feature=2020-resolver .)

