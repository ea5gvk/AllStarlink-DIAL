#! /bin/sh

# Get the kernel-headers for the running kernel
apt-get install linux-headers-`uname -r` -y

###########################################################

# Get Asterisk
cd /usr/src
# svn checkout http://svn.ohnosec.org/svn/projects/allstar/astsrc-1.4.23-pre/trunk astsrc-1.4.23-pre
git clone https://github.com/AllStarLink/Asterisk.git astsrc-1.4.23-pre

# grab the svn version number and put it where asterisk/Makefile expects it.
cd /usr/src/astsrc-1.4.23-pre
echo "1538" >asterisk/.version

# download uridiag
# svn co http://svn.ohnosec.org/svn/projects/allstar/uridiag/trunk uridiag
git clone https://github.com/AllStarLink/uridiag.git

# Get DAHDI from GitHub
# As of 8-20-2016 dahdi-linux-complete-current.tar.gz is already in the DL directory.
# I'll move it when this version of the Bare Metal Installer is official.
# mkdir -p /srv/download
# cd /srv/download
# wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
# wget https://github.com/N4IRS/AllStar/raw/master/dahdi-linux-complete-current.tar.gz

# Clean out unneeded source and add dahdi source
cd /usr/src/astsrc-1.4.23-pre
# rm -rf libpri
rm -rf zaptel
tar zxvf /srv/download/dahdi-linux-complete-current.tar.gz
mv dahdi-linux-complete* dahdi-linux-complete

##########################################################




