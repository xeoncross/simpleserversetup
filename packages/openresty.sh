#!/bin/bash

# Openresty doesn't act like apache or nginx - it installs itself like a lib to /usr/local/openresty
# We could install openresty like nginx: http://brian.akins.org/blog/2013/03/19/building-openresty-on-ubuntu/
# but what if we want to have an openresty+lua server and an nginx+go install running at the same time?
# Solution, just leave openresty looking more like calling a lib since the nginx.conf is the "app" anyway
# https://github.com/jiko/OpenResty-Vagrant/blob/master/install.sh

# Openresty need these packages
apt-get -qq install libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make > /dev/null

if [[ ! -d /usr/local/openresty ]]; then

	OPENRESTY_VERSION="1.7.0.1"

	if [[ $params ]]; then
		OPENRESTY_VERSION=$params
	fi

	print_warn "Installing openresty $OPENRESTY_VERSION"

	wget -q "http://openresty.org/download/ngx_openresty-$OPENRESTY_VERSION.tar.gz"

	tar -xzvf "ngx_openresty-$OPENRESTY_VERSION.tar.gz"

	if cd "ngx_openresty-$OPENRESTY_VERSION"; then
		./configure --with-luajit --prefix=/usr/local/openresty > /dev/null
		make -s > /dev/null

		if make -s install; then
			
			# We might want to run openresty with an APT version of nginx
			# (Some webservices might need a different nginx compile)
			#PATH=/usr/local/openresty/nginx/sbin:$PATH
			#export PATH

			#openresty_path=/usr/local/openresty/nginx/sbin/nginx

			# Make it easier to type
			ln -s /usr/local/openresty/nginx/sbin/nginx /usr/sbin/openrestynginx

			# Create a sites-enabled directory where we will ln -s our lua-app configs
			mkdir -p /usr/local/openresty/nginx/sites-enabled/

			# Backup the original
			mv /usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf.backup
			rm /usr/local/openresty/nginx/conf/nginx.conf

			# Copy our new config over
			cp "$VPS_Base/config/openresty-nginx-conf" /usr/local/openresty/nginx/nginx.conf

			print_success "Openresty installed to /usr/local/openresty/"
			print_warn "Call with 'openrestynginx'"
			echo "http://openresty.org/#GettingStarted"

			# apt-get install luarocks
			# luarocks install lua-cjson
			# /usr/local/openresty/nginx/sbin/nginx -p `pwd`/ -c conf/nginx.conf
			# httperf --num-calls 100 --num-conns 10000 --max-connections 10000 --server localhost --port 8080
		fi
	fi
fi

if [ ! -d /var/www/openresty/localhost ]; then
	mkdir -m 775 -p /var/www/openresty/localhost/{conf,logs,html,lua}
	cp "$VPS_Base/config/openresty-localhost-conf" /var/www/openresty/localhost/conf/localhost.conf
	ln -s /var/www/openresty/localhost/conf/localhost.conf /usr/local/openresty/nginx/sites-enabled/localhost.conf

	cp "$VPS_Base/config/openresty-websockets-html" /var/www/openresty/localhost/html/websockets.html
	cp "$VPS_Base/config/openresty-websockets.lua" /var/www/openresty/localhost/lua/websockets.lua

	print_warn "Demo openresty application installed to /var/www/openresty/localhost/"
	#echo "[then start openresty with this current path and config]"
	#print_warn "openrestynginx -p \`pwd\`/ -c conf/nginx.conf'"
fi
