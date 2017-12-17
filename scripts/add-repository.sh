#!/usr/bin/env bash
set -o errexit

# N4IRS 07/26/2017

################################################
#                                              #
# Add official repository for AllStar Asterisk #
#                                              #
################################################

cd /etc/apt/sources.list.d
wget http://dvswitch.org/ASL_Repository/allstarlink.list
wget -O - http://dvswitch.org/ASL_Repository/allstarlink.gpg.key | apt-key add -
apt-get update




