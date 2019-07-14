#!/bin/bash

# this gets run on host to build the image

set -e
function cleanup {
  sudo umount -f "${ROOT}/boot/"
  sudo umount -f "${ROOT}"
  rm -rf "${ROOT}"
}
trap cleanup EXIT
ROOT=$(mktemp -d)
LOOP=$(sudo losetup --show -fP "${1}")
sudo mount "${LOOP}p2" "${ROOT}"
sudo mount "${LOOP}p1" "${ROOT}/boot/"

cp builder/config.txt "${ROOT}/boot/"
cp -R patches "${ROOT}/boot/"
cp -R assets "${ROOT}/boot/"
cp -R zerostomp.py "${ROOT}/boot/"
cp builder/rc.local "${ROOT}/etc/rc.local"
cp builder/startup.sh "${ROOT}/boot/startup.sh"
