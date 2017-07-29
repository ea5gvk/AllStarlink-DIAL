#!/usr/bin/env bash
set -o errexit

# N4IRS 07/26/2017

################################################
#                                              #
# Add official repository for AllStar Asterisk #
#                                              #
################################################

wget -O - http://dvswitch.org/ASL_Repository/keyFile | sudo apt-key add -
cp /srv/repository/AllStarLink.list /etc/apt/sources.list.d
apt-get update




