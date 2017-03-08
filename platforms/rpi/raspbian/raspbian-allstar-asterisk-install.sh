#!/bin/sh -e

# Do basic housekeeping on image
dpkg-reconfigure locales
dpkg-reconfigure tzdata

systemctl set-default multi-user.target
ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

# Don't allow kernel updates
echo "raspberrypi-bootloader hold" | dpkg --set-selections
echo "raspberrypi-kernel hold" | dpkg --set-selections

apt-get update
apt-get upgrade -y

# install required
/srv/scripts/required_libs.sh

# install i2c for RPi
apt-get install libi2c-dev -y
apt-get install i2c-tools -y

# install build_tools
/srv/scripts/build_tools.sh

# get AllSter and DAHDI
/srv/scripts/get_src.sh

# install kernel source for RPi
/srv/scripts/install-RPi-kernel-source.sh

# build DAHDI
/srv/scripts/build_dahdi.sh

# build libpri
/srv/scripts/build_libpri.sh

# patch and build Asterisk
/srv/scripts/patch_asterisk.sh

# Don't install init.d scripts
# Ugly but effective
# Move this to patch_asterisk and add Debian version test
sed -i -e 's/debian_version/debian_version_7/g' /usr/src/astsrc-1.4.23-pre/asterisk/Makefile

/srv/scripts/build_asterisk.sh

# make /dev/dsp available
# not needed for a hub
# though it will not hurt anything.
echo snd_pcm_oss >>/etc/modules

# Add asterisk to logrotate
/srv/scripts/mk_logrotate_asterisk.sh

# Install user scripts
cp /srv/post_install/* /usr/local/sbin

# Install Nodelist updater
cp /usr/src/astsrc-1.4.23-pre/allstar/rc.updatenodelist /usr/local/bin/rc.updatenodelist
cp /srv/scripts/log2ram /usr/local/bin

# Add SayIP
cp -rf /srv/sayip /usr/local/
# This needs work
# cd /etc
# patch </srv/patches/patch-rc.local

# Start asterisk on boot
cp /srv/systemd/asterisk.service /lib/systemd/system
systemctl enable asterisk.service
cp /srv/systemd/updatenodelist.service /lib/systemd/system
systemctl enable updatenodelist.service
cp /srv/systemd/log2ram.service /lib/systemd/system
systemctl enable log2ram.service

# Check for updates once per day
ln -fs /usr/local/sbin/check-update.sh /etc/cron.daily/check-update.sh

# replace the files needed for supporting and testing the PiTA
cp /srv/PiTA/cirrus.conf /etc/modprobe.d
cp /srv/PiTA/cmdline.txt /boot
cp /srv/PiTA/config.txt /boot
cp /srv/PiTA/modules /etc
cp /srv/PiTA/modules.conf /etc/asterisk
cp /srv/PiTA/rpt.conf /etc/asterisk
cp /srv/PiTA/simpleusb.conf /etc/asterisk

touch /etc/asterisk/firsttime

echo "test -e /etc/asterisk/firsttime && /usr/local/sbin/firsttime" >>/root/.bashrc

echo "Please reboot now"


