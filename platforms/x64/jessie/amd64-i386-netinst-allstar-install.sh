#!/usr/bin/env bash
set -o errexit

# N4IRS 07/26/2017

#################################################
#                                               #
#                                               #
#                                               #
#################################################

# This script will run the first time the system boots. Even
# though we've told it to run after networking is enabled,
# I've observed inconsistent behavior if we start hitting the
# net immediately.
#
# Introducing a brief sleep makes things work right all the
# time. This needs to be checked again and see if we can remove it.

# No need for NFS or rpcbind
apt-get remove nfs-common -y
apt-get purge rpcbind -y
apt-get autoremove -y
echo "removed NFS and rpcbind" >>/var/log/install.log

chage -d 0 repeater
# echo "Force Password change for repeater" >>/var/log/install.log

# Enable and start systemd networking
systemctl enable systemd-networkd.service
systemctl start systemd-networkd.service

systemctl enable systemd-networkd systemd-resolved
systemctl start systemd-networkd systemd-resolved
# ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
echo "start networking" >>/var/log/install.log

systemctl set-default multi-user.target
ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

sleep 20

# setup ntpdate
# add hourly clock adjustment
apt-get install ntpdate -y
ln -s /etc/network/if-up.d/ntpdate /etc/cron.hourly/ntpdate
echo "Install ntpdate" >>/var/log/install.log

#### End x86 stuff ####

# To be removed

# Log UDP and TCP listeners during install process
echo > /var/log/netstat.txt
echo "At the top of the script" >> /var/log/netstat.txt
echo  >> /var/log/netstat.txt
echo "netstat -unap" >> /var/log/netstat.txt
netstat -unap >> /var/log/netstat.txt
echo "netstat -tnap" >> /var/log/netstat.txt
netstat -tnap >> /var/log/netstat.txt

# DL AllStar master
echo "start DL of AllStar Asterisk master" >>/var/log/install.log

cd /tmp
wget --no-check-certificate https://github.com/AllStarLink/DIAL/archive/master.zip
echo "download master.zip" >>/var/log/install.log

# unzip the master
apt-get install unzip -y
rm -f AllStar-master
ln -s /srv AllStar-master
unzip master.zip
rm AllStar-master
echo "decompress master.zip" >>/var/log/install.log

# put rc.local back to default
# Should be a simple copy
cd /etc
patch </srv/patches/patch-amd64-i386-stock-netinstall-rc.local
echo "put rc.local back to default" >>/var/log/install.log

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

# Add asterisk to logrotate
/srv/scripts/mk_logrotate_asterisk.sh

# Put user scripts into /usr/local/sbin
cp -rf /srv/post_install/* /usr/local/sbin

# Check this out. I think it's done by modified asterisk Makefile now.
# Could be redundant.

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
# ln -s /usr/local/sbin/check-update.sh /etc/cron.daily/check-update.sh
# touch /var/tmp/update.old

# touch /etc/asterisk/firsttime

# echo "test -e /etc/asterisk/firsttime && /usr/local/sbin/firsttime" >>/root/.bashrc

sleep 5

# ugly!
mv /var/log/install.log /var/log/install_phase2.log

# To be removed

# Log UDP and TCP listeners during install process
echo >> /var/log/netstat.txt
echo "At the bottom of the script" >> /var/log/netstat.txt
echo  >> /var/log/netstat.txt
netstat -unap >> /var/log/netstat.txt
netstat -tnap >> /var/log/netstat.txt

# Reboot into the system
echo "AllStar Asterisk install Complete, rebooting" >>/var/log/install.log

/sbin/reboot

