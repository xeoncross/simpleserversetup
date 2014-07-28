#!/bin/bash

# Thanks too https://gist.github.com/markselby/7190522

# Latest version right now
version=1.7.2.1

# Allow the user to change the openresty version
if [[ $params ]]; then
	version=$params
fi

NGINX_SRC="/opt/openresty"

# Move into the directory we'll work from
mkdir -p $NGINX_SRC
cd $NGINX_SRC

# Build dependencies for nginx and all modules below
apt-get -qq install --assume-yes make build-essential git libpcre3 libpcre3-dev libssl-dev \
	libgeoip-dev nginx libpq-dev libreadline-dev libncurses5-dev perl make

# download nginx
if [[ ! -d ngx_openresty-$version ]]; then

	print_warn "downloading openresty $version"
	wget http://openresty.org/download/ngx_openresty-$version.tar.gz
	tar -zxvf ngx_openresty-$version.tar.gz

fi


if [[ ! -d drizzle7-2011.07.21 ]]; then

	print_warn "downloading drizzle7"
	# http://openresty.org/#DrizzleNginxModule 
	# The latest drizzle7 release does not support building libdrizzle 1.0 separately
	# and requires a lot of external dependencies like Boost and Protobuf
	wget -O drizzle7-2011.07.21.tar.gz "http://openresty.org/download/drizzle7-2011.07.21.tar.gz"
	tar xzvf drizzle7-2011.07.21.tar.gz
	cd drizzle7-2011.07.21/
	./configure --without-server
	make libdrizzle-1.0 > /dev/null
	make install-libdrizzle-1.0 > /dev/null
	cd ..
fi



cd "ngx_openresty-$version"

# clone extensions
if [[ ! -d ext ]]; then

	mkdir ext
	cd ext

	print_warn "Cloning git projects"
	git clone https://github.com/arut/nginx-rtmp-module.git
	git clone https://github.com/nbs-system/naxsi.git
	# We will use --add-module below to add these

	cd ..
fi


print_warn 'Setting up configuration for make'

./configure \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-log-path=/var/log/nginx/access.log \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
--lock-path=/var/lock/nginx.lock \
--pid-path=/run/nginx.pid \
--user=www-data \
--group=www-data \
--with-luajit \
--with-mail \
--with-ipv6 \
--with-file-aio \
--with-ld-opt="-Wl,-rpath,/usr/local/lib" \
--with-http_drizzle_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_geoip_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_stub_status_module \
--with-mail_ssl_module \
--with-http_sub_module \
--with-sha1=/usr/include/openssl \
--with-md5=/usr/include/openssl \
--with-http_stub_status_module \
--with-http_secure_link_module \
--with-http_sub_module \
--add-module=ext/nginx-rtmp-module \
--add-module=ext/naxsi/naxsi_src/ \
--with-http_postgres_module > /dev/null

print_warn 'make...'
make > /dev/null

print_warn 'make install...'
make install > /dev/null


# Nginx HTTP server boilerplate configs
if [ ! -d /etc/nginx-previous ]; then
	mv /etc/nginx /etc/nginx-previous
fi

git clone https://github.com/h5bp/server-configs-nginx.git /etc/nginx

##############
# @depreciated
##############

# Only backup the original config once
# if [ ! -f /etc/nginx/nginx.default.conf ]; then
# 	mv /etc/nginx/nginx.conf /etc/nginx/nginx.default.conf
# fi

# # Copy our new config over
# cp "$VPS_Base/config/openresty-nginx-conf" /etc/nginx/nginx.conf


# @todo
# if [ ! -d /var/www/openresty/localhost ]; then
# 	mkdir -m 775 -p /var/www/openresty/localhost/{conf,logs,html,lua}
# 	cp "$VPS_Base/config/openresty-localhost-conf" /var/www/openresty/localhost/conf/localhost.conf
# 	ln -s /var/www/openresty/localhost/conf/localhost.conf /usr/local/openresty/nginx/sites-enabled/localhost.conf

# 	cp "$VPS_Base/config/openresty-websockets-html" /var/www/openresty/localhost/html/websockets.html
# 	cp "$VPS_Base/config/openresty-websockets.lua" /var/www/openresty/localhost/lua/websockets.lua

# 	print_warn "Demo openresty application installed to /var/www/openresty/localhost/"
# 	#echo "[then start openresty with this current path and config]"
# 	#print_warn "openrestynginx -p \`pwd\`/ -c conf/nginx.conf'"
# fi
