#!/bin/bash

set -e
function cleanup {
  sudo umount -f "${ROOT}/boot/"
  sudo umount -f "${ROOT}"
  rmdir "${ROOT}"
}
trap cleanup EXIT
ROOT=$(./emu/mountloop.sh "${1}")

cp emu/config.txt "${ROOT}/boot/"
cp emu/rc.local "${ROOT}/etc/rc.local"
cp emu/startup-dev.sh "${ROOT}/boot/startup.sh"