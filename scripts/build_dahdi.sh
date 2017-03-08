#! /bin/sh

##############################################
#                                            #
# Patch and build dahdi for AllStar Asterisk #
#                                            #
##############################################

cd /usr/src/astsrc-1.4.23-pre/dahdi-linux-complete/

# Patch dahdi for use with AllStar Asterisk
# https://allstarlink.org/dude-dahdi-2.10.0.1-patches-20150306
# Soon to be included in the official release of DAHDI from Digium.
patch -p1 < /srv/patches/patch-dahdi-dude-current

# remove setting the owner to asterisk
patch -p0 < /srv/patches/patch-dahdi.rules

# Build and install dahdi
make all
make install
make config

# Dont need and dahdi hardware drivers loaded for most installs

##################################################################

# change this to setup dahdi for quad card
mv /etc/dahdi/modules /etc/dahdi/modules.old



