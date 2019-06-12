#!/bin/bash

# this is all run in the context of a pi, booted with network
# It will not be run in normal operation
# it's just to setup the initial developer image

# save filesystem layout for next boot
mkdir -p /boot/zerostomp/patches
echo -e "\n/dev/sdb1 /boot/zerostomp/patches vfat default 0 0" >> /etc/fstab

# update OS
apt update -y
apt upgrade -y

# setup puredata
apt install puredata

# gem puredata-utils puredata-extra puredata-import pd-3dp pd-arraysize pd-aubio pd-bassemu pd-beatpipe pd-boids pd-bsaylor pd-chaos pd-comport pd-csound pd-cxc pd-cyclone pd-earplug pd-ekext pd-ext13 pd-fftease pd-flite pd-freeverb pd-ggee pd-hcs pd-hid pd-iemambi pd-iemlib pd-iemmatrix pd-iemnet pd-jmmmp pd-libdir pd-list-abs pd-lua pd-lyonpotpourri pd-mapping pd-markex pd-maxlib pd-mjlib pd-moonlib pd-motex pd-osc pd-pan pd-pddp pd-pdogg pd-pdp pd-pdstring pd-plugin pd-pmpd pd-purepd pd-readanysf pd-sigpack pd-smlib pd-unauthorized pd-vbap pd-wiimote pd-windowing pd-zexy

# overwrite this script with startup command
echo -e "puredata -nogui /boot/zerostomp/patches/MAIN.pd &\n" > /boot/startup.sh

# halt v-machine
poweroff