#!/bin/bash
# N4IRS 03/08/2017

# This script is intended to instal ASL on a fresh Debian Linux
# ALL and I'll say again ALL it does is install ASL It's up to you
# To configure your OS

#### End x86 stuff ####

# install required
/srv/scripts/required_libs.sh
echo "install required libs" >>/var/log/install.log

# install build_tools
/srv/scripts/build_tools.sh
echo "install build tools" >>/var/log/install.log

# get AllSter, DAHDI and kernel headers
/srv/scripts/get_src.sh
echo "Get source complete" >>/var/log/install.log

# ugly!
cp /var/log/install.log /var/log/install_phase1.log

# build DAHDI
/srv/scripts/build_dahdi.sh
echo "build DAHDI complete" >>/var/log/install.log

# build libpri
/srv/scripts/build_libpri.sh
echo "build libpri complete" >>/var/log/install.log

# patch Asterisk
/srv/scripts/patch_asterisk.sh

# Build Asterisk
/srv/scripts/build_asterisk.sh
echo "build Asterisk complete" >>/var/log/install.log

# make /dev/dsp available
# not needed for a hub
# Though it will not hurt anything.
echo snd_pcm_oss >>/etc/modules
echo "created /dev/dsp" >>/var/log/install.log

# Put user scripts into /usr/local/sbin
cp -rf /srv/post_install/* /usr/local/sbin

codename=$(lsb_release -cs)
if [[ $codename == 'jessie' ]]; then
  echo "codename is Jessie, using systemd units" >>/var/log/install.log
  # start update node list on boot
  cp /usr/src/astsrc-1.4.23-pre/allstar/rc.updatenodelist /usr/local/bin/rc.updatenodelist
  cp /srv/systemd/updatenodelist.service /lib/systemd/system
  systemctl enable updatenodelist.service
  echo "setup start update node list" >>/var/log/install.log
  # Start asterisk on boot
  cp /srv/systemd/asterisk.service /lib/systemd/system
  systemctl enable asterisk.service
elif [[ $codename == 'wheezy' ]]; then
  echo "codename is Wheezy, using init scripts"  >>/var/log/install.log
  # Patch rc.local to start updatenodelist
  # Should I be using different post install scripts?
  # Should I modify the init scripts for safe asterisk?
  # Is the world really round
fi

# Install Log2RAM
# cp /srv/scripts/log2ram /usr/local/bin
# cp /srv/systemd/log2ram.service /lib/systemd/system
# systemctl enable log2ram.service
# echo "Install and enable log2ram" >>/var/log/install.log
# ln -s /usr/local/sbin/flush-log /etc/cron.hourly/flush-log

# Move this. OK for now
ln -s /usr/local/sbin/check-update.sh /etc/cron.daily/check-update.sh
touch /var/tmp/update.old

# touch /etc/asterisk/firsttime

# echo "test -e /etc/asterisk/firsttime && /usr/local/sbin/firsttime" >>/root/.bashrc

sleep 5

# ugly!
mv /var/log/install.log /var/log/install_phase2.log

