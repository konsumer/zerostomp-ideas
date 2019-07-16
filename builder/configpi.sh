#!/bin/bash

# this is all run in the context of a pi, booted with network
# It will not be run in normal operation
# it's just to setup the initial developer image
# /usr/rpi should be a volume-mount of this repo

echo "" > /etc/ld.so.preload

# setup some files
touch /boot/ssh
cp /usr/rpi/builder/config.txt /boot/
cp /usr/rpi/builder/cmdline.txt /boot/
cp -R /usr/rpi/patches /boot/
cp -R /usr/rpi/assets /boot/
cp /usr/rpi/zerostomp.py /boot/
cp /usr/rpi/builder/rc.local /etc/rc.local
cp /usr/rpi/builder/startup.sh /boot/startup.sh

# update OS
apt update -y
apt upgrade -y

# setup puredata
apt install -y python3-pip software-properties-common
pip3 install python-osc

# install purr-data
# this is outdated for Raspbian/buster
# wget https://github.com/agraef/purr-data/releases/download/2.9.0/pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip
# unzip pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip
# apt install ./pd-l2ork-2.9.0-20190416-rev.2b3f27c1-armv7l.deb
# rm pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip pd-l2ork-2.9.0-20190416-rev.2b3f27c1-armv7l.deb




# TODO: do more optimization here

# change name to "zerostomp"
echo "zerostomp" > /etc/hostname
sed -i s/raspberrypi/zerostomp/g /etc/hosts

apt-get autoclean
apt-get clean
apt-get autoremove