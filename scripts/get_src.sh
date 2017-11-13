#!/usr/bin/env bash
set -o errexit

# N4IRS 07/26/2017

#################################################
#                                               #
#                                               #
#                                               #
#################################################

# Get Kernel Headers
distributor=$(lsb_release -is)
if [[ $distributor = "Raspbian" ]]; then
apt-get install raspberrypi-kernel-headers -y
elif [[ $distributor = "Debian" ]]; then
apt-get install linux-headers-`uname -r` -y
fi

###########################################################

# Get Asterisk
cd /usr/src
# svn checkout http://svn.ohnosec.org/svn/projects/allstar/astsrc-1.4.23-pre/trunk astsrc-1.4.23-pre
git clone https://github.com/AllStarLink/Asterisk.git astsrc-1.4.23-pre

# grab the svn version number and put it where asterisk/Makefile expects it.
cd /usr/src/astsrc-1.4.23-pre
# echo "1538" >asterisk/.version
echo "GIT Version" `git log -1 --format="%h"` >asterisk/.version

# download uridiag
# svn co http://svn.ohnosec.org/svn/projects/allstar/uridiag/trunk uridiag
git clone https://github.com/AllStarLink/uridiag.git

mkdir -p /usr/src/astsrc-1.4.23-pre/asterisk/contrib/systemd
cp /srv/systemd/asterisk.service /usr/src/astsrc-1.4.23-pre/asterisk/contrib/systemd
cp /srv/systemd/updatenodelist.service /usr/src/astsrc-1.4.23-pre/asterisk/contrib/systemd

# Clean out unneeded source
cd /usr/src/astsrc-1.4.23-pre
rm -rf libpri
rm -rf zaptel

##########################################################




