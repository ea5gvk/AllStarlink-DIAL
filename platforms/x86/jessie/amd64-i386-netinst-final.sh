
# This is only a test. This file will be merged into preseed.cfg

# d-i preseed/late_command string \
# in-target wget https://github.com/AllStarLink/DIAL/raw/master/platforms/x86/jessie/amd64-i386-netinst-image-prep.sh -O /tmp/amd64-i386-netinst-image-prep.sh ; \
# in-target /bin/sh /tmp/amd64-i386-netinst-image-prep.sh ; echo "amd64-i386-netinst-image-prep.sh run" >>/var/log/automated_install
#
# Force user repeater to change password on first login
# d-i preseed/late_command string in-target passwd --expire repeater

passwd --expire repeater

# stop sshd from listening to ipv6
# wget https://github.com/AllStarLink/DIAL/raw/master/patches/patch-sshd_config -O /tmp/patch-sshd_config
# cd  /etc/ssh
# patch </tmp/patch-sshd_config

# disable exim4 daemon
# wget https://github.com/AllStarLink/DIAL/raw/master/patches/patch-exim4 -O /tmp/patch-exim4
# cd /etc/default/
# patch </tmp/patch-exim4

# Disable /etc/network/interfaces
# This could be a simple delete file

# Setup systemd networking

####################################

# No need for NFS or rpcbind

# systemctl set-default multi-user.target
# ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

# setup ntpdate
# add hourly clock adjustment
# ln -s /etc/network/if-up.d/ntpdate /etc/cron.hourly/ntpdate

# install build_tools

# make /dev/dsp available
# Is this done by allstarlink install?
# echo snd_pcm_oss >>/etc/modules
# echo "created /dev/dsp" >>/var/log/install.log

# blacklist gmvideo for Atom MB
echo 'blacklist gma500_gfx' >> /etc/modprobe.d/blacklist.conf
# depmod -ae
# update-initramfs -u

# Install Log2RAM

# touch /etc/asterisk/firsttime

# echo "test -e /etc/asterisk/firsttime && /usr/local/sbin/firsttime" >>/root/.bashrc

