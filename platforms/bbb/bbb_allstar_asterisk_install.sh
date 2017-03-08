#! /bin/sh

#########################################################
#                                                       #
# script was built for bbb AllStar Asterisk install.    #
#                                                       #
#########################################################

/srv/scripts/required_libs.sh
/srv/scripts/build_tools.sh
/srv/scripts/get_src.sh

/srv/scripts/build_dahdi.sh
/srv/scripts/build_asterisk.sh

# moved steps below from build_asterisk to platform install file

# make /dev/dsp available
# not needed for a hub
# Though it will not hurt anything.
echo snd_pcm_oss >>/etc/modules

# start update node list on boot
cd /etc
patch < /srv/patches/patch-rc.local

echo " If all looks good, edit iax.conf extensions.conf and rpt.conf"
echo " Pay attention to the top of rpt.conf"

