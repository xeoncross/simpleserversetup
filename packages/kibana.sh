#!/bin/bash

# install kibana dashboard for elasticsearch
# http://www.elasticsearch.org/overview/kibana/

apt-get -qq --assume-yes install unzip > /dev/null

if [ ! -d "/opt/kibana" ]; then

	# No ppa for kibana yet!
	wget http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip
	unzip kibana-latest.zip -d /opt > /dev/null

	#mkdir -p /var/www/kibana/
	#chmod 775 /var/www/kibana/

	mv /opt/kibana-latest/ /opt/kibana
fi
