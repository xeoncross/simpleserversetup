#!/bin/bash

apt-get -qq install php5-cli php5-fpm > /dev/null 2>&1

if [[ $? == 0 ]]; then

	# Copy our custom ini over if allowed
	if [[ -d /etc/php5/conf.d && ! -f /etc/php5/conf.d/custom_php.ini ]]; then

		if [[ -f $VPS_Base/$1/config/php.ini ]]; then
			cp $VPS_Base/$1/config/php.ini /etc/php5/conf.d/custom_php.ini
			echo "$1/config/php.ini to /etc/php5/conf.d/custom_php.ini"
		elif [[ -f $VPS_Base/config/php.ini ]]; then
			cp $VPS_Base/$config/php.ini /etc/php5/conf.d/custom_php.ini
			echo "config/php.ini to /etc/php5/conf.d/custom_php.ini"
		fi

		#invoke-rc.d mysql start
		service php5-fpm restart > /dev/null

	fi

fi
