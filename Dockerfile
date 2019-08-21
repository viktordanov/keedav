FROM alpine:3.10.2

ENV WWW_ROOT=/var/www/html \
        CONF_PATH=/etc/lighttpd/conf.d \
        START_PATH=/usr/local/bin/start.d

RUN apk add --no-cache \
        lighttpd \
        apache2-utils \
        lighttpd-mod_auth \
        lighttpd-mod_webdav \
        git \
        && rm -rf /var/www/localhost \
        && mkdir -p $CONF_PATH $START_PATH \
        && git clone --branch gh-pages --depth 1 https://github.com/keeweb/keeweb $WWW_ROOT \
        && rm -r $WWW_ROOT/.git

COPY 20-webdav.sh $START_PATH
COPY 20-webdav.conf $CONF_PATH

COPY 10-basic.conf 11-compress.conf $CONF_PATH/
COPY run.sh /usr/local/bin/run.sh

WORKDIR $WWW_ROOT

EXPOSE 80

ENTRYPOINT ["run.sh"]
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
