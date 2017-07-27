#!/usr/bin/env bash
set -o errexit

# N4IRS 07/26/2017

#################################################
#                                               #
#                                               #
#                                               #
#################################################

# Get Asterisk
cd /usr/src/astsrc-1.4.23-pre
svn update .

# grab the svn version number and put it where asterisk/Makefile expects it.
cd /usr/src/astsrc-1.4.23-pre
svnversion >asterisk/.version

# Clean out unneeded source
cd /usr/src/astsrc-1.4.23-pre
rm -rf zaptel

# Apply updates
cd /usr/src/astsrc-1.4.23-pre/asterisk
make
make install



