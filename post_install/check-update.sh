#! /bin/sh

wget --no-check-certificate https://github.com/N4IRS/AllStar/raw/master/update -O /var/tmp/update > /dev/null 2>&1

hash1=`md5sum /var/tmp/update | awk '{print $1}'`
hash2=`md5sum /var/tmp/update.old | awk '{print $1}'`

if [ $hash1 = $hash2 ]
then
  rm /var/tmp/update ; exit
fi

chmod +x /var/tmp/update > /dev/null 2>&1

/var/tmp/update > /dev/null 2>&1

mv /var/tmp/update /var/tmp/update.old
