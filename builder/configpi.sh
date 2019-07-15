#!/bin/bash

# this is all run in the context of a pi, booted with network
# It will not be run in normal operation
# it's just to setup the initial developer image

echo "" > /etc/ld.so.preload

# update OS
apt update -y
apt upgrade -y

# setup puredata
apt install -y python3-pip
pip3 install python-osc

# install purr-data
wget https://github.com/agraef/purr-data/releases/download/2.9.0/pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip
unzip pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip
apt install pd-l2ork-2.9.0-20190416-rev.2b3f27c1-armv7l.deb
rm pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip pd-l2ork-2.9.0-20190416-rev.2b3f27c1-armv7l.deb

# TODO: do more optimization here

# overwrite this script with startup command
echo -e "#!/bin/sh\npython3 /boot/zerostomp.py &\npd-l2ork -nogui /boot/patches/MAIN.pd &\n" > /boot/startup.sh

# chnage name to "zerostomp"
echo "zerostomp" > /etc/hostname
sed -i s/raspberrypi/zerostomp/g /etc/hosts