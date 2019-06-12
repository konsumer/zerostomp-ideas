#!/bin/bash

# Use this to make a disk-image that will run whatever is in /boot/startup.sh

TMP=$(mktemp -d)

LOOP=$(sudo losetup --show -fP "${1}")
sudo mount "${LOOP}p2" "${TMP}"
sudo mount "${LOOP}p1" "${TMP}/boot/"

echo $TMP