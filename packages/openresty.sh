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
		make > /dev/null

		if make install > /dev/null; then
			
			# We might want to run openresty with an APT version of nginx
			# (Some webservices might need a different nginx compile)
			#PATH=/usr/local/openresty/nginx/sbin:$PATH
			#export PATH

			if [[ ! -d /var/www/openresty/localhost ]]; then
				mkdir /var/www/openresty/localhost/{conf,logs}
				cp $VPS_BASE/config/openresty-localhost-config /var/www/openresty/localhost/conf/nginx.conf
			fi

			print_success "Openresty installed to /usr/local/openresty/"
			echo "http://openresty.org/#GettingStarted"
			print_warn "cd /var/www/openresty/localhost/"
			echo "[then start openresty with this current path and config]"
			print_warn "/usr/local/openresty/nginx/sbin/nginx -p \`pwd\`/ -c conf/nginx.conf'"

			# apt-get install luarocks
			# luarocks install lua-cjson
			# /usr/local/openresty/nginx/sbin/nginx -p `pwd`/ -c conf/nginx.conf
			# httperf --num-calls 100 --num-conns 10000 --max-connections 10000 --server localhost --port 8080
		fi
	fi
fi

#wget -q https://raw.github.com/pixelb/ps_mem/master/ps_mem.py -O /usr/local/sbin/ps_mem && chmod +x /usr/local/sbin/ps_mem