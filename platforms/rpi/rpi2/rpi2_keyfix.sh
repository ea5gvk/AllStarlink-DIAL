#! /bin/sh

# Fix KEYEXPIRED errors during apt-get update

cd /tmp
wget https://repositories.collabora.co.uk/debian/pool/rpi2/c/collabora-obs-archive-keyring/collabora-obs-archive-keyring_0.5+b1_all.deb
dpkg -i collabora-obs-archive-keyring_0.5+b1_all.deb
apt-get update


