#!/bin/sh

# this is run when the pi starts up

python3 /boot/zerostomp.py &
pd-l2ork -nogui /boot/patches/MAIN.pd &
