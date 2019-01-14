FROM viossat/keeweb:latest

RUN apk add --no-cache \
	apache2-utils \
	lighttpd-mod_auth \
	lighttpd-mod_webdav

COPY 20-webdav.sh $START_PATH
COPY 20-webdav.conf $CONF_PATH
