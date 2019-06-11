#!/bin/bash

# get libs & tools
apt update
apt upgrade -y
apt install -y git

# setup libpd

# this is the actual build I used
#git clone --recursive https://github.com/libpd/libpd
#cd libpd
#git checkout 0.11.0
#make
#make install
#cd ..
#rm -rf libpd

wget https://github.com/konsumer/zerostomp/releases/download/0.0.0/libpd.tgz
tar -xzf libpd.tgz
cd libpd
cp -R * /usr/local/
cd ..
rm -rf libpd

# install node
wget https://nodejs.org/dist/latest-v10.x/node-v10.16.0-linux-armv6l.tar.gz
tar -xzf node-v10.16.0-linux-armv6l.tar.gz
cd node-v10.16.0-linux-armv6l
cp -R * /usr/local/
cd ..
rm -rf node-v10.16.0-linux-armv6l*

# cd /media/zerostomp
# npm i
# npm run genpd
