#!/bin/bash

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

cp emu/config.txt "${ROOT}/boot/"
cp emu/rc.local "${ROOT}/etc/rc.local"
cp emu/startup.sh "${ROOT}/boot/startup.sh"