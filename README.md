# p0tter/keedav

Free cross-platform password manager compatible with KeePass. https://keeweb.info/

This image supports WebDAV, this makes possible to store/sync password files on the same container.

Note: Over WebDAV, KeeWeb can update files but can't currently create them, the files must exist.

- Alpine-based
- **now with TLS support!**

## Usage
### Without TLS (HTTP)
First, start KeeWeb (`/my/password-files` must contain the password file):
```bash
docker run -d -p 80:80 -e WEBDAV_USERNAME=webdav -e WEBDAV_PASSWORD=secret -v /my/password-files:/var/www/html/webdav p0tter/keedav:1.2
```
### With TLS (HTTPS)
The container will automatically generate the file `/etc/lighttpd/ssl.pem` for lighttpd out of the given `ssl.key` and `ssl.crt` file:
```bash
docker run -d -p 443:443 -e WEBDAV_USERNAME=webdav -e WEBDAV_PASSWORD=secret -v /my/ssl.key:/certs/ssl.key:ro -v /my/ssl.crt:/certs/ssl.crt:ro -v /my/password-files:/var/www/html/webdav p0tter/keedav:1.2
```
alternatively use a already generated `ssl.pem` file:
```bash
docker run -d -p 443:443 -e WEBDAV_USERNAME=webdav -e WEBDAV_PASSWORD=secret -v /my/ssl.pem:/etc/lighttpd/ssl.pem:ro -v /my/password-files:/var/www/html/webdav p0tter/keedav:1.2
```
Then, go to KeeWeb through your browser, click on `More`, click on `WebDAV` and enter your configuration:
```
URL: https://example.com/webdav/filenanme
Username: webdav
Password: secret
```
## Docker-Compose
### Without TLS (HTTP)
```
version: "3"

services:
  keeweb:
    image: p0tter/keedav:1.2
    expose:
      - "80"
    restart: always
    environment:
      - WEBDAV_USERNAME=webdav
      - WEBDAV_PASSWORD=secret
    volumes:
      - /my/password-files:/var/www/html/webdav
```
### With TLS (HTTPS)
The container will automatically generate the file `/etc/lighttpd/ssl.pem` for lighttpd out of the given `ssl.key` and `ssl.crt` file:
```
version: "3"

services:
  keeweb:
    image: p0tter/keedav:1.2
    restart: always
    expose:
      - "443"
    environment:
      - WEBDAV_USERNAME=webdav
      - WEBDAV_PASSWORD=secret
    volumes:
      - /my/password-files:/var/www/html/webdav
      - /my/ssl.key:/certs/ssl.key:ro
      - /my/ssl.crt:/certs/ssl.crt:ro
```
alternatively use a already generated `ssl.pem` file:
```
version: "3"

services:
  keeweb:
    image: p0tter/keedav:1.2
    expose:
      - "443"
    restart: always
    environment:
      - WEBDAV_USERNAME=webdav
      - WEBDAV_PASSWORD=secret
    volumes:
      - /my/password-files:/var/www/html/webdav
      - /my/ssl.pem:/etc/lighttpd/ssl.pem:ro
```
