#!/bin/sh

cd /opt/models/research/models/research/

# install pip
curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py

python3 get-pip.py --force-reinstall

python3 -m pip install --user --upgrade pip

# Compile protos.
protoc /opt/models/research/object_detection/protos/*.proto --python_out=.

# Install TensorFlow Object Detection API.
cp /opt/models/research/object_detection/packages/tf1/setup.py .
python3 -m pip install --use-feature=2020-resolver .

pip install labelImg

apt-get install '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev

# Test the installation.
python3 /opt/models/research/object_detection/builders/model_builder_tf1_test.py


# Install Kinova-Kortex
sudo apt install -y python3 python3-pip
sudo python3 -m pip install conan
conan config set general.revisions_enabled=1
conan profile new default --detect > /dev/null
conan profile update settings.compiler.libcxx=libstdc++11 default

cd /root/kinova-gen3-docker/kinova_ws && rosdep install --from-paths src --ignore-src -r -y


