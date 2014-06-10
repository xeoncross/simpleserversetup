#!/bin/bash

if [[ ! -e /usr/local/bin/phpunit ]]; then
	wget -q https://phar.phpunit.de/phpunit.phar -O /usr/local/bin/phpunit && chmod +x /usr/local/bin/phpunit
	echo "/usr/local/bin/phpunit"
fi