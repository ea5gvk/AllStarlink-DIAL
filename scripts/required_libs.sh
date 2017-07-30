#!/usr/bin/env bash
set -o errexit

# N4IRS 07/26/2017

#####################################################
#                                                   #
# Install libs required to install AllStar Asterisk #
#                                                   #
#####################################################

apt-get install libusb-dev -y
apt-get install libnewt-dev -y
apt-get install libeditline0 -y
apt-get install libncurses5-dev -y

apt-get install bison -y

apt-get install libssl-dev -y

apt-get install libasound2-dev -y

apt-get install libcurl4-gnutls-dev -y

apt-get install php5-cli -y

apt-get install libiksemel-dev -y

apt-get install libvorbis-dev -y

apt-get install curl -y

# Nice to have utilities and tools
# is sox required or nice to have
apt-get install sox -y
apt-get install usbutils -y
apt-get install alsa-utils -y
apt-get install bc -y
apt-get install dnsutils -y
apt-get install libsnmp-dev -y
