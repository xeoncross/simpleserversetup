#!/bin/bash

if [[ ! -d /etc/csf ]]; then
	
	#cd /tmp
	rm -fv csf.tgz
	wget http://www.configserver.com/free/csf.tgz
	tar -xzf csf.tgz
	cd csf
	sh install.sh > /dev/null

	perl /usr/local/csf/bin/csftest.pl

	echo "CSF is installed and running in test mode."
	print_warn "Please edit /etc/csf/csf.conf"

	# Use our custom conf
	#cp $VPS_Base/config/csf.conf /etc/csf/csf.conf

fi