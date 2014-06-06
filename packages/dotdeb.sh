#!/bin/bash

# Only install dotdeb for debian machines - ubuntu doesn't need it
if [[ VPS_OS == "debian" ]]; then

	# Debian version 6.x.x
	if grep ^6. /etc/debian_version > /dev/null
	then
		echo "deb http://packages.dotdeb.org squeeze all" >> /etc/apt/sources.list
		echo "deb-src http://packages.dotdeb.org squeeze all" >> /etc/apt/sources.list
	fi

	# Debian version 7.x.x
	if grep ^7. /etc/debian_version > /dev/null
	then
		echo "deb http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list
		echo "deb-src http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list
	fi

	wget -q -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -

else
	print_warn "Skipping dotdeb for $VPS_OS $VPS_OS_Codename"
fi