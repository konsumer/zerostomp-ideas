#!/bin/bash

# this is all run in the context of a pi, booted with network (inside chroot)

# change hostname to "zerostomp"
echo "zerostomp" > /etc/hostname
sed -i s/raspberrypi/zerostomp/g /etc/hosts

# update OS
apt update -y
apt upgrade -y

# setup puredata
apt install -y python3-pil python3-pip software-properties-common
pip3 install python-osc

# install purr-data
# this is outdated for Raspbian/buster
# wget https://github.com/agraef/purr-data/releases/download/2.9.0/pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip
# unzip pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip
# apt install ./pd-l2ork-2.9.0-20190416-rev.2b3f27c1-armv7l.deb
# rm pd-l2ork-2.9.0-raspbian_stretch-armv7l.zip pd-l2ork-2.9.0-20190416-rev.2b3f27c1-armv7l.deb

# I built this with "make images/purr-data/pd-l2ork-2.9.0-20190624-rev.e2b3cc4a-armv7l.deb" then uploaded to github
wget https://github.com/konsumer/zerostomp/releases/download/pd-buster/pd-l2ork-2.9.0-20190624-rev.e2b3cc4a-armv7l.deb
apt install -y ./pd-l2ork-2.9.0-20190624-rev.e2b3cc4a-armv7l.deb
rm pd-l2ork-2.9.0-20190624-rev.e2b3cc4a-armv7l.deb


# TODO: do more optimization here

apt-get autoclean
apt-get clean
apt-get autoremove