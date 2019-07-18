#!/bin/bash

if (( $# < 3 )); then
  echo "Usage: chroot.sh IMAGE_FILE MOUNT_POINT ...CHROOT_ARGS"
  exit 1
fi

# grab first 2 arguments, and leave rest of arguments
IMAGE="${1}"
shift
ROOT="${1}"
shift
CHROOT_ARGS=$@

if [ ! -f "${IMAGE}" ]; then
  echo "Image file ${IMAGE} does not exist"
  exit 1
fi

# unmount loopback on exit
set -e
function cleanup {
  umount -f "${ROOT}/boot/"
  umount -f "${ROOT}/usr/rpi"
  umount -f "${ROOT}"
}
trap cleanup EXIT

echo "Attempting to mount ${IMAGE} to ${ROOT}"

# Attach loopback device
LOOP_BASE=$(losetup -f --show "${IMAGE}")

echo "Attached base loopback at: ${LOOP_BASE}"

# TODO: could grab this from fdisk instead of hard coding
BLOCK_SIZE=512

# Fetch and parse partition info
P1_INFO=($`fdisk -l "${LOOP_BASE}" | grep p1`)
P2_INFO=($`fdisk -l "${LOOP_BASE}" | grep p2`)

# Locate partition start sectors
P1_START=${P1_INFO[1]}
P2_START=${P2_INFO[1]}

echo "Located partitions: p1 (/boot) at ${P1_START} and p2 (/) at ${P2_START}"

# Cleanup loopbacks
losetup -d "${LOOP_BASE}"
echo "Closed loopback ${LOOP_BASE}"

# Mount image with the offsets determined above
echo "Mounting to ${ROOT} and ${ROOT}/boot"
mkdir -p "${ROOT}"
mount "${IMAGE}" -o loop,offset=$(($P2_START*$BLOCK_SIZE)),rw "${ROOT}"
mount "${IMAGE}" -o loop,offset=$(($P1_START*$BLOCK_SIZE)),sizelimit=$((85405*$BLOCK_SIZE)),rw "${ROOT}/boot"

echo "Binding /usr/rpi into ${ROOT} for chroot"
mkdir -p "${ROOT}/usr/rpi"
mount --bind /usr/rpi "${ROOT}/usr/rpi"

# setup some files
echo "Setting up some basic system files in ${ROOT}"
echo "" > "${ROOT}/etc/ld.so.preload"
touch "${ROOT}/boot/ssh"
cp /usr/rpi/builder/config.txt "${ROOT}/boot/"
cp /usr/rpi/builder/cmdline.txt "${ROOT}/boot/"
cp /usr/rpi/zerostomp.py "${ROOT}/boot/"
cp /usr/rpi/builder/rc.local "${ROOT}/etc/rc.local"
cp /usr/rpi/builder/startup.sh "${ROOT}/boot/startup.sh"
cp -R /usr/rpi/patches "${ROOT}/boot/"
cp -R /usr/rpi/assets "${ROOT}/boot/"

echo "running chroot ${ROOT} ${CHROOT_ARGS}"
chroot "${ROOT}" $CHROOT_ARGS