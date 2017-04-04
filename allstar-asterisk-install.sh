#!/bin/bash
# N4IRS 04/04/2017

# This script will install AllStarLink Asterisk on a existing Debian installation.

# DL AllStar master
cd /tmp
wget --no-check-certificate https://github.com/AllStarLink/DIAL/archive/master.zip

# unzip the master
apt-get install unzip -y
rm -f DIAL-master
ln -s /srv DIAL-master
unzip master.zip
rm DIAL-master

# install required
/srv/scripts/required_libs.sh

# install build_tools
/srv/scripts/build_tools.sh

# get AllSter, DAHDI and kernel headers
/srv/scripts/get_src.sh

# build DAHDI
/srv/scripts/build_dahdi.sh

# patch Asterisk
/srv/scripts/patch_asterisk.sh

# Build Asterisk
/srv/scripts/build_asterisk.sh

# make /dev/dsp available
# not needed for a hub
# Though it will not hurt anything.
echo snd_pcm_oss >>/etc/modules

# Put user scripts into /usr/local/sbin
cp -rf /srv/post_install/* /usr/local/sbin

codename=$(lsb_release -cs)
if [[ $codename == 'jessie' ]]; then
  # start update node list on boot
  cp /usr/src/astsrc-1.4.23-pre/allstar/rc.updatenodelist /usr/local/bin/rc.updatenodelist
  cp /srv/systemd/updatenodelist.service /lib/systemd/system
  systemctl enable updatenodelist.service
  # Start asterisk on boot
  cp /srv/systemd/asterisk.service /lib/systemd/system
  systemctl enable asterisk.service
fi

# Move this. OK for now
ln -s /usr/local/sbin/check-update.sh /etc/cron.daily/check-update.sh
touch /var/tmp/update.old

touch /etc/asterisk/firsttime

echo "test -e /etc/asterisk/firsttime && /usr/local/sbin/firsttime" >>/root/.bashrc

echo "AllStar Asterisk install Complete."

echo reboot

