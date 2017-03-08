#! /bin/sh

# change governor to performance
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# add performance setting to rc.local for rpi
cd /etc
patch < /srv/patches/patch-rpi-rc.local

# keep raspberrypi-bootloader at current version.
# Don't let it upgrade the kernel.
echo "raspberrypi-bootloader hold" | dpkg --set-selections

# Make sure we are running the latest and greatest
apt-get update -y
apt-get purge --auto-remove 'libx11-.*'
apt-get dist-upgrade -y

# Add re-generate SSL keys <--------------------------------

# Install 3.12  kernel and matching headers
# apt-get install linux-image-3.12-1-rpi -y
# apt-get install linux-headers-3.12-1-rpi -y

# add to /boot/config.txt
# cd /boot
# patch < /srv/patches/patch-rpi1-3-12-config.txt

# Install 3.18  kernel and matching headers
apt-get install linux-image-3.18.0-trunk-rpi -y
apt-get install linux-headers-3.18.0-trunk-rpi -y

# add to /boot/config.txt
cd /boot
patch < /srv/patches/patch-rpi1-3-18-config.txt

# set the locales and time zone
dpkg-reconfigure locales
dpkg-reconfigure tzdata

# change USB to USB 1.1
# hold off on this
# patch < /srv/patches/patch-rpi1-cmdline.txt

# Raspberry Pi will show the DHCP assigned address.
# Recomended:
# change from DHCP to static IP

# At this point you can either continue on the USB console or
# switch over to SSH login on your LAN.
# easier since you can now copy and paste from this document to the SSH screen.

# pistar login: pi
# Password: Your_Secret_Password_From_Above

# set the root password
# sudo -s
# passwd root
#	Enter new UNIX password: Your_very_secret_password
#	Retype new UNIX password: Your_very_secret_password

#### Move this to get_src and comment out
#### add patch for makeopts

# this may be removed. Keep for now
# At least turn this into a patch
# install ilbc
# cp /srv/replaced/get_ilbc_source.sh ./contrib/scripts/get_ilbc_source.sh
echo "REBOOT before you run the install script"


