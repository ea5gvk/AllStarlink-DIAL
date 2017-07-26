#!/usr/bin/env bash
set -o errexit

# N4IRS 07/26/2017

###################################
# Get AllStar master from github  #
#                                 #
# More then 1 way to skin a cat   #
#                                 #
###################################

cd /tmp
wget --no-check-certificate https://github.com/N4IRS/AllStar/archive/master.zip
rm AllStar-master
ln -s /srv AllStar-master
unzip master.zip
rm AllStar-master
