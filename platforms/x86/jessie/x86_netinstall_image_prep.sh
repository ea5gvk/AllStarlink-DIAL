#!/bin/sh

# DL firstboot script and put in in /usr/local/bin
wget https://github.com/N4IRS/AllStar/raw/master/platforms/x86/jessie/x86_netinstall_allstar_asterisk_install.sh -O /srv/x86_netinstall_allstar_asterisk_install.sh

# DL firstboot rc.local patch and put in in /tmp
wget https://github.com/N4IRS/AllStar/raw/master/patches/patch-x86-first-netinstall-rc.local -O /tmp/patch-x86-first-netinstall-rc.local

# make the script executable
chmod +x /srv/x86_netinstall_allstar_asterisk_install.sh

# create /var/log/install.log
echo "Install log created" >/var/log/install.log

# modify rc.local to run firstboot
cd /etc
patch </tmp/patch-x86-first-netinstall-rc.local
echo "rc.local modified to run x86_netinstall_allstar_asterisk_install.sh" >>/var/log/install.log

# stop sshd from listening to ipv6
wget https://github.com/N4IRS/AllStar/raw/master/patches/patch-sshd_config -O /tmp/patch-sshd_config
cd  /etc/ssh
patch </tmp/patch-sshd_config
echo "removed sshd ipv6 listener" >>/var/log/install.log

# disable exim4 daemon
wget https://github.com/N4IRS/AllStar/raw/master/patches/patch-exim4 -O /tmp/patch-exim4
cd /etc/default/
patch </tmp/patch-exim4
echo "disabled exim4 daemon" >>/var/log/install.log

# Disable /etc/network/interfaces
# This could be a simple delete file
wget https://github.com/N4IRS/AllStar/raw/master/patches/patch-interfaces -O /tmp/patch-interfaces
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

