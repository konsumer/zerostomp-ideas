#!/bin/sh

# pre-built binaries of purr-data weren't available for buster, so I build my own

apt-get update

apt-get install -y git wget rsync bison flex automake libasound2-dev \
      libjack-jackd2-dev libtool libbluetooth-dev libgl1-mesa-dev \
      libglu1-mesa-dev libglew-dev libmagick++-dev libftgl-dev \
      libgmerlin-dev libgmerlin-avdec-dev libavifile-0.7-dev \
      libmpeg3-dev libquicktime-dev libv4l-dev libraw1394-dev \
      libdc1394-22-dev libfftw3-dev libvorbis-dev ladspa-sdk \
      dssi-dev tap-plugins invada-studio-plugins-ladspa blepvco \
      swh-plugins mcp-plugins cmt blop omins rev-plugins \
      dssi-utils vco-plugins wah-plugins fil-plugins \
      mda-lv2 libmp3lame-dev libspeex-dev libgsl0-dev \
      portaudio19-dev liblua5.3-dev python-dev libsmpeg0 libjpeg62-turbo \
      flite1-dev libgsm1-dev libgtk2.0-dev git libstk0-dev \
      libfluidsynth-dev fluid-soundfont-gm byacc gconf2 libnss3

git clone --depth 1 https://git.purrdata.net/jwilkes/purr-data.git /usr/rpi/images/purr-data
cd /usr/rpi/images/purr-data
make all