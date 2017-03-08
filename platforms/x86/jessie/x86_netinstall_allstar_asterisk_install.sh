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
echo "removed NFS and rpcbind" >>/var/log/install.log


# Enable and start systemd networking
systemctl enable systemd-networkd.service
systemctl start systemd-networkd.service

systemctl enable systemd-networkd systemd-resolved
systemctl start systemd-networkd systemd-resolved
# ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
echo "start networking" >>/var/log/install.log

sleep 20

# Log UDP and TCP listeners during install process
echo > /var/log/netstat.txt
echo "At the top of the script" >> /var/log/netstat.txt
echo  >> /var/log/netstat.txt
echo "netstat -unap" >> /var/log/netstat.txt
netstat -unap >> /var/log/netstat.txt
echo "netstat -tnap" >> /var/log/netstat.txt
netstat -tnap >> /var/log/netstat.txt

apt-get update
apt-get upgrade -y

# DL x86 tar ball
echo "start DL of AllStar Asterisk install" >>/var/log/install.log

cd /srv
wget https://github.com/N4IRS/AllStar/raw/master/x86.tar.gz
echo "download tar ball" >>/var/log/install.log

# untar x86 script
tar zxvf x86.tar.gz
echo "decompress x86.tar.gz" >>/var/log/install.log

# setup ntpdate
# add hourly clock adjustment
apt-get install ntpdate -y
ln -s /etc/network/if-up.d/ntpdate /etc/cron.hourly/ntpdate
echo "Install ntpdate" >>/var/log/install.log

# put rc.local back to default
cd /etc
patch </srv/patches/patch-x86-stock-netinstall-rc.local
echo "put rc.local back to default" >>/var/log/install.log

# install required
/srv/scripts/required_libs.sh
echo "install required libs" >>/var/log/install.log

# install required
/srv/scripts/build_tools.sh
echo "install build tools" >>/var/log/install.log

# needs to be moved
# apt-get install curl -y

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

# Build Asterisk
/srv/scripts/build_asterisk.sh
echo "build Asterisk complete" >>/var/log/install.log

# moved steps below from build_asterisk to platform install file

# make /dev/dsp available
# not needed for a hub
# Though it will not hurt anything.
echo snd_pcm_oss >>/etc/modules
echo "created /dev/dsp" >>/var/log/install.log

# start update node list on boot
cd /etc
patch < /srv/patches/patch-rc.local
echo "setup start update node list" >>/var/log/install.log

# Add asterisk to logrotate
/srv/scripts/mk_logrotate_asterisk.sh
echo "added asterisk to logrotate" >>/var/log/install.log

# Reboot into the system
echo "AllStar Asterisk install Complete, rebooting" >>/var/log/install.log

# Log UDP and TCP listeners during install process
echo >> /var/log/netstat.txt
echo "At the bottom of the script" >> /var/log/netstat.txt
echo  >> /var/log/netstat.txt
netstat -unap >> /var/log/netstat.txt
netstat -tnap >> /var/log/netstat.txt

# setup for Phase 3
cp /srv/post_install/* /usr/local/sbin

touch /etc/asterisk/firsttime

echo "test -e /etc/asterisk/firsttime && /usr/local/sbin/firsttime" >>/root/.bashrc

sleep 5

# ugly!
mv /var/log/install.log /var/log/install_phase2.log

/sbin/reboot

