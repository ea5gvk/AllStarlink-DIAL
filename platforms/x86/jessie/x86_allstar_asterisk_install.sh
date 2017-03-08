#!/bin/sh -e

# This script will run the first time the system boots. Even
# though we've told it to run after networking is enabled,
# I've observed inconsistent behavior if we start hitting the
# net immediately.
#
# Introducing a brief sleep makes things work right all the
# time. This needs to be checked again and see if we can remove it.

# No need for NFS or rpcbind
# can this be moved to run BEFORE networking is started?
apt-get remove nfs-common -y
apt-get purge rpcbind -y
apt-get autoremove -y

cd /srv
wget https://github.com/N4IRS/AllStar/raw/master/x86.tar.gz

# untar x86 script
tar zxvf x86.tar.gz

# setup ntpdate
# add hourly clock adjustment
apt-get install ntpdate -y
ln -s /etc/network/if-up.d/ntpdate /etc/cron.hourly/ntpdate

# install required
/srv/scripts/required_libs.sh

# install build_tools
/srv/scripts/build_tools.sh

# get AllSter, DAHDI and kernel headers
/srv/scripts/get_src.sh

# build DAHDI
/srv/scripts/build_dahdi.sh

# build libpri
/srv/scripts/build_libpri.sh

# Build Asterisk
/srv/scripts/build_asterisk.sh

# make /dev/dsp available
# not needed for a hub
# Though it will not hurt anything.
echo snd_pcm_oss >>/etc/modules

# start update node list on boot
cd /etc
patch < /srv/patches/patch-rc.local

# Add asterisk to logrotate
/srv/scripts/mk_logrotate_asterisk.sh

# Reboot into the system

# setup for Phase 3
cp /srv/post_install/* /usr/local/sbin

touch /etc/asterisk/firsttime

echo "test -e /etc/asterisk/firsttime && /usr/local/sbin/firsttime" >>/root/.bashrc

echo "Please reboot now"
