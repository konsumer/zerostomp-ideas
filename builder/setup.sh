#!/bin/bash

# this gets run on host to build the image

set -e
function cleanup {
  sudo umount -f "${ROOT}/boot/"
  sudo umount -f "${ROOT}"
  rm -rf "${ROOT}"
  losetup -d "${LOOP}"
}
trap cleanup EXIT

ROOT=$(mktemp -d)
LOOP=$(losetup --show -fP "${1}")

mount "${LOOP}p2" "${ROOT}"
mount "${LOOP}p1" "${ROOT}/boot/"

touch "${ROOT}/boot/ssh"
cp builder/config.txt "${ROOT}/boot/"
cp builder/cmdline.txt "${ROOT}/boot/"
cp -R patches "${ROOT}/boot/"
cp -R assets "${ROOT}/boot/"
cp zerostomp.py "${ROOT}/boot/"
cp builder/rc.local "${ROOT}/etc/rc.local"
cp builder/startup.sh "${ROOT}/boot/startup.sh"

chroot "${ROOT}" /boot/startup.sh