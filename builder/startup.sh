#!/bin/bash

# this is all run in the context of a pi, booted with network
# It will not be run in normal operation
# it's just to setup the initial developer image

# save filesystem layout for next boot
mkdir -p /boot/patches

TMP=$(mktemp -d)
mount /dev/sdb1 "${TMP}"
cp -R "${TMP}" /boot/patches

# update OS
apt update -y
apt upgrade -y

# setup puredata
apt install -y puredata python3-pip
pip3 install python-osc

# TODO: install these? use purr-data instead?
# gem puredata-utils puredata-extra puredata-import pd-3dp pd-arraysize pd-aubio pd-bassemu pd-beatpipe pd-boids pd-bsaylor pd-chaos pd-comport pd-csound pd-cxc pd-cyclone pd-earplug pd-ekext pd-ext13 pd-fftease pd-flite pd-freeverb pd-ggee pd-hcs pd-hid pd-iemambi pd-iemlib pd-iemmatrix pd-iemnet pd-jmmmp pd-libdir pd-list-abs pd-lua pd-lyonpotpourri pd-mapping pd-markex pd-maxlib pd-mjlib pd-moonlib pd-motex pd-osc pd-pan pd-pddp pd-pdogg pd-pdp pd-pdstring pd-plugin pd-pmpd pd-purepd pd-readanysf pd-sigpack pd-smlib pd-unauthorized pd-vbap pd-wiimote pd-windowing pd-zexy

# TODO: do more optimization here

# overwrite this script with startup command
echo -e "python3 /boot/patches/MAIN.py &\n" > /boot/startup.sh

# halt v-machine
poweroff