#!/bin/bash

if [[ $(whoami) != "root" ]]; then
	echo -e "\e[1;31mPlease run as root\e[0m" && exit 1
fi

# Decompress the APT history if needed
if [ -n "$( ls -A -tr /var/log/apt/history.log*.gz )" ]; then
	zcat $( ls -tr /var/log/apt/history.log*.gz ) > /dev/null 2>&1
fi

# Output the APT log in reverse order with oldest commands first so we can "re-play" them

# Only show the install history
if [[ ! $1 ]]; then
	# Decompress the APT log and find all the installed packages (ignore the other APT commands)
	echo "`cat /var/log/apt/history.log | egrep '^Commandline: apt-get .+? install ([^\^]*)$' | sed '/ APT::/d' | egrep -o 'install .+' | sed -e 's/install [^a-zA-Z0-0]*//g' | tr " " "\n" | tr "=" " " | nl | sort -k 2 -u | sort -k 1n | cut -f 2-`"
else
	# Full APT log to find all removed, purged, and installed packages
	echo "`cat /var/log/apt/history.log | egrep '^Commandline: apt-get .* (install|remove|purge) ([^\^]*)$' | egrep -o 'apt-get .+' | nl | sort -k 2 -u | sort -k 1n | cut -f 2-`"
fi

exit 0