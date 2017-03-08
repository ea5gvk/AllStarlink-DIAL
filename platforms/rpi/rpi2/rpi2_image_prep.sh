#! /bin/sh
#########################################################
#                                                       #
# Image prepare script was built for rpi2 install.      #
#                                                       #
#########################################################

# change governor to performance
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# add performance setting to rc.local for rpi
cd /etc
patch < /srv/patches/patch-rpi-rc.local

# set the locales and time zone
dpkg-reconfigure locales
dpkg-reconfigure tzdata

timedatectl set-ntp true

cd /srv/download
wget https://repositories.collabora.co.uk/debian/pool/rpi2/c/collabora-obs-archive-keyring/collabora-obs-archive-keyring_0.5+b1_all.deb
dpkg -i collabora-obs-archive-keyring_0.5+b1_all.deb

echo "deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi" >>/etc/apt/sources.list
wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -

# Make sure we are running the latest and greatest
apt-get update -y
apt-get dist-upgrade -y

# Add re-generate SSL keys
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

echo "If you saw no errors above REBOOT now!"


