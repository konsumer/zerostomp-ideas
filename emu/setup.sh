#!/bin/bash

# this is all run in the context of the pi, booted with network
# It will not be run in normal operation
# it's just to setup the initial image

curl -sSL https://get.docker.com | sh

apt upgrade -y

# [fast boot linux](http://himeshp.blogspot.com/2018/08/fast-boot-with-raspberry-pi.html) (under 2s)

apt-get purge --remove plymouth -y
cp /media/zerostomp/config.txt /boot/
cp /media/zerostomp/zerostomp.service /etc/systemd/system/

systemctl disable dhcpcd.service
systemctl disable networking.service
systemctl disable ssh.service
systemctl disable ntp.service
systemctl disable dphys-swapfile.service
systemctl disable keyboard-setup.service
systemctl disable apt-daily.service
systemctl disable wifi-country.service
systemctl disable hciuart.service
systemctl disable raspi-config.service
systemctl disable avahi-daemon.service
systemctl disable triggerhappy.service

# TODO: systemd-analyze critical-chain to get a better list of services to disable
# TODO: steps 5,6,7 (kernel optimization)

# TODO: optimizations:
#
# [optimize sound, in general](https://wiki.linuxaudio.org/wiki/raspberrypi)
# [optimize usb sound](https://computers.tutsplus.com/articles/using-a-usb-audio-device-with-a-raspberry-pi--mac-55876)