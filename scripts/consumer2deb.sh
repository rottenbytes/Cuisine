#!/bin/sh

which fpm > /dev/null
ret=$?

if [ ! $ret -eq 0 ] ; then
  echo "FPM not found in the PATH"
  exit 1
fi

mkdir -p tmp_deb/etc/cuisine
mkdir -p tmp_deb/usr/bin
mkdir -p tmp_deb/etc/init.d

cp initd_cuisine-consumer tmp_deb/etc/init.d/cuisine-consumer
cp cuisine-consumer tmp_deb/usr/bin
cp ../config/cuisine.yml.dist tmp_deb/etc/cuisine/cuisine.yml

echo "#!/bin/bash" > postinst.sh
echo "chown -R root:root /etc/cuisine /usr/bin/cuisine-consumer /etc/init.d/cuisine-consumer" >> postinst.sh
chmod +x postinst.sh


fpm -s dir -t deb -n cuisine-consumer -v 0.0.1 -C tmp_deb -a all --url "https://github.com/rottenbytes/Cuisine" --description "data consumer for cuisine" -m nico@rottenbytes.info --post-install ./postinst.sh

rm -rf tmp_deb
rm -f postinst.sh

