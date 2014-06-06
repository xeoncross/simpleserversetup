#!/bin/bash

# Is this even needed? Seems some systems don't create it
if [[ ! -d /var/www ]]; then
	mkdir /var/www
fi

# Make sure the snake-oil certs exist (for SSL on nginx)
apt-get -qq install ssl-cert > /dev/null

# Ships default with some ubuntu (older ubuntu and debian need ssl-cert first)
make-ssl-cert generate-default-snakeoil --force-overwrite

#todo add ${params[1]} support here!
# install nginx ${params[1]}
apt-get -qq install nginx

if [[ $? == 0 ]]; then

	## Create our SSL certificate
	#if [[ ! -d /etc/nginx/ssl ]]; then
	#	mkdir /etc/nginx/ssl
	#fi
	#
	#if [[ ! -e /etc/nginx/ssl/server.key ]]; then
	#	echo "Generate Nginx server private key..."
	#	vvvgenrsa="$(openssl genrsa -out /etc/nginx/ssl/server.key 2048 2>&1)"
	#	echo $vvvgenrsa
	#fi
	#
	#if [[ ! -e /etc/nginx/ssl/server.csr ]]; then
	#	echo "Generate Certificate Signing Request (CSR)..."
	#	openssl req -new -batch -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr
	#fi
	#
	#if [[ ! -e /etc/nginx/ssl/server.crt ]]; then
	#	echo "Sign the certificate using the above private key and CSR..."
	#	vvvsigncert="$(openssl x509 -req -days 365 -in /etc/nginx/ssl/server.csr -signkey /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt 2>&1)"
	#	echo $vvvsigncert
	#fi

fi

# This might be a bad idea if this script is run a second time...
chown -R www-data:www-data /var/www 

# Copy our default "multisite" configuration over
if [[ ! -e /etc/nginx/sites-available/nginx-sites-conf ]]; then
	cp $VPS_Base/config/nginx-sites-conf /etc/nginx/sites-available/nginx-sites-conf
	
	ln -sl /etc/nginx/sites-available/nginx-sites-conf /etc/nginx/sites-enabled/nginx-sites-conf

	service nginx restart
fi



