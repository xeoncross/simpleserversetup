#!/bin/bash

newuser="www-data"

if [ -z "$params" ]; then
	newuser="$params"
fi

# This script reads over all the directories in /var/www/ and makes them
# owned (and writable) by www-data without touching the files that exist
# Perfect for keeping configs and project files from prying eyes while
# Opening up file uploads or such
find /var/www -type d -exec chmod 755 {} + -exec chown "$newuser:$newuser" {} +

print_success "$newuser now owns all directories inside /var/www/"