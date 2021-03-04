rm /usr/bin/pppd /usr/local/sbin/pppd
make -C pppd clean
make -C pppd install
cp /usr/local/sbin/pppd /usr/bin/pppd
