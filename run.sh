#!/bin/sh
set -eu

chown -R lighttpd /var/log/lighttpd && chmod -R u+rw /var/log/lighttpd
chown -R lighttpd $WWW_ROOT && chmod u+r -R $WWW_ROOT
tail -F -n 0 /var/log/lighttpd/access.log /var/log/lighttpd/error.log 2> /dev/null &

find $START_PATH -type f | sort | while read start; do
    $start
done
find $CONF_PATH -type f | sort | xargs cat > /etc/lighttpd/lighttpd.conf

if [ -e /certs/ssl.key ] && [ -e /certs/ssl.crt ];then
    cat /certs/ssl.key > /etc/lighttpd/ssl.pem
    echo >> /etc/lighttpd/ssl.pem
    cat /certs/ssl.crt >> /etc/lighttpd/ssl.pem
fi

if [ -e /etc/lighttpd/ssl.pem ];then
    echo "server.port = 443" >> /etc/lighttpd/lighttpd.conf
    echo "ssl.engine = \"enable\"" >> /etc/lighttpd/lighttpd.conf
    echo "ssl.pemfile = \"/etc/lighttpd/ssl.pem\"" >> /etc/lighttpd/lighttpd.conf
    echo "SSL Cert-File found! Going with HTTPS (Port 443)!"
else
    echo "No SSL Cert-File found! Going with HTTP (Port 80)!"
fi

exec "$@"
