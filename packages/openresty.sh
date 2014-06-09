#!/bin/bash

# Openresty need these packages
apt-get -qq install libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make > /dev/null

if [[ ! -d /etc/openresty ]]; then

	OPENRESTY_VERSION="1.7.0.1"

	if [[ ${params[1]} ]]; then
		OPENRESTY_VERSION=${params[1]}
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

			print_success "Openresty installed to /usr/local/openresty/nginx/sbin/nginx"
			print_warn "http://openresty.org/#GettingStarted"
			echo "cd /var/www/example.com"
			echo "mkdir logs/ conf/"
			echo "vim conf/nginx.conf"
			echo "...type config and save..."
			#echo "Create your sites in /var/www/example.com/{logs,conf}"
			echo "then start openresty with this current path and config"
			echo "/usr/local/openresty/nginx/sbin/nginx -p \`pwd\`/ -c conf/nginx.conf'"

			# httperf --num-calls 100 --num-conns 10000 --max-connections 10000 --server localhost --port 8080
		fi
	fi
fi

#wget -q https://raw.github.com/pixelb/ps_mem/master/ps_mem.py -O /usr/local/sbin/ps_mem && chmod +x /usr/local/sbin/ps_mem