#!/bin/sh

##################################
#                                #
# Setup to install on first boot #
#                                #
##################################
# 08/21/2016
# N4IRS

# DL firstboot script and put in in /srv
wget https://github.com/AllStarLink/DIAL/raw/master/platforms/x64/jessie/amd64-i386-netinst-allstar-install.sh -O /srv/amd64-i386-netinst-allstar-install.sh

# DL firstboot rc.local patch and put in in /tmp
wget https://github.com/AllStarLink/DIAL/raw/master/patches/patch-amd64-i386-first-netinstall-rc.local -O /tmp/patch-amd64-i386-first-netinstall-rc.local

# make the script executable
chmod +x /srv/amd64-i386-netinst-allstar-install.sh

# create /var/log/install.log
echo "Install log created" >/var/log/install.log

# modify rc.local to run firstboot
cd /etc
patch </tmp/patch-amd64-i386-first-netinstall-rc.local
echo "rc.local modified to run amd64-i386-netinst-allstar-install.sh" >>/var/log/install.log

# stop sshd from listening to ipv6
wget https://github.com/AllStarLink/DIAL/raw/master/patches/patch-sshd_config -O /tmp/patch-sshd_config
cd  /etc/ssh
patch </tmp/patch-sshd_config
echo "removed sshd ipv6 listener" >>/var/log/install.log

# disable exim4 daemon
AllStarLink/DIALwget https://github.com/AllStarLink/DIAL/raw/master/patches/patch-exim4 -O /tmp/patch-exim4
cd /etc/default/
patch </tmp/patch-exim4
echo "disabled exim4 daemon" >>/var/log/install.log

# Disable /etc/network/interfaces
# This could be a simple delete file
wget https://github.com/AllStarLink/DIAL/raw/master/patches/patch-interfaces -O /tmp/patch-interfaces
cd /etc/network
patch </tmp/patch-interfaces
echo "Disabled /etc/network/interfaces" >>/var/log/install.log

# Setup systemd networking
echo "[Match]" >>/etc/systemd/network/eth0.network
echo "Name=eth0" >>/etc/systemd/network/eth0.network
echo >>/etc/systemd/network/eth0.network
echo "[Network]" >>/etc/systemd/network/eth0.network
echo "DHCP=v4" >>/etc/systemd/network/eth0.network
echo >>/etc/systemd/network/eth0.network
echo "make systemd eth0.network" >>/var/log/install.log

