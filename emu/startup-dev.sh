#!/bin/bash

# this is all run in the context of a pi, booted with network
# It will not be run in normal operation
# it's just to setup the initial developer image

# save filesystem layout for next boot
mkdir -p /media/zerostomp/emu /media/zerostomp/app /boot/zerostomp/patches
echo "" >> /etc/fstab
echo "/dev/sdb1 /media/zerostomp/emu vfat default 0 0" >> /etc/fstab
echo "/dev/sdc1 /media/zerostomp/app vfat default 0 0" >> /etc/fstab
echo "/dev/sdd1 /boot/zerostomp/patches vfat default 0 0" >> /etc/fstab

# update OS
apt update -y
apt upgrade -y

# setup libpd
apt install -y libjack-dev libasound2-dev git
git clone --depth 1 --recursive https://github.com/libpd/libpd /root/libpd && cd /root/libpd && make && make install

# halt v-machine
poweroff