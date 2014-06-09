#!/bin/bash

if [ -z "${params[1]}" ]; then
	exit_error "Please enter the domain name for mysql_new_user [domain]"
fi

domain_name="${params[1]}"

if [ ! -d "/var/www/$domain_name/" ]; then
	mkdir "/var/www/$domain_name/"
	mkdir "/var/www/$domain_name/public"
	#exit_error "no site found at /var/www/$domain_name/"
fi

# Setting up the MySQL database
dbname=`echo $domain_name | tr . _`
userid=`get_domain_name $domain_name`
# MySQL userid cannot be more than 15 characters long
userid="${userid:0:15}"
passwd=`random_string 25`

if mysqladmin create "$dbname"; then
	echo "GRANT ALL PRIVILEGES ON \`$dbname\`.* TO \`$userid\`@localhost IDENTIFIED BY '$passwd';" | \
		mysql

	cat > "/var/www/$domain_name/mysql.conf" <<END
[mysql]
user = $userid
password = $passwd
database = $dbname
END
	chmod 600 "/var/www/$domain_name/mysql.conf"


	# We could also add these...
	#echo "DROP USER '$userid'@'localhost';" | \ mysql
	#echo "DROP DATABASE IF EXISTS  `$dbname` ;" | \ mysql

	print_success "New MySQL database/user $domain_name created"
	print_success "Saved details to /var/www/$domain_name/mysql.conf"
	#print_success "MySQL Username: $userid"
	#print_success "MySQL Password: $passwd"
	#print_success "MySQL Database: $dbname"
else
	print_error "Could not create database for $domain_name"
fi