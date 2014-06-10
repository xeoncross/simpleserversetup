#!/bin/bash

if dpkg -s mysql-server  > /dev/null 2>&1; then
	print_warn "MySQL is already installed. See: '/root/.my.cnf'"
else

	passwd=`random_string 20`
	debconf-set-selections <<< "mysql-server mysql-server/root_password password $passwd"
	debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $passwd"

	DEBIAN_FRONTEND=noninteractive apt-get -qq install expect mysql-server mysql-client > /dev/null 2>&1

	if [[ $? == 0 ]]; then

		# Copy the MySQL config over
		if [[ -f $VPS_Base/$config_directory/config/mysql.cnf ]]; then
			cp $VPS_Base/$config_directory/config/mysql.cnf /etc/mysql/conf.d/mysql.cnf
		elif [[ -f $VPS_Base/config/mysql.cnf ]]; then
			cp $VPS_Base/$config/mysql.cnf /etc/mysql/conf.d/mysql.cnf
		fi

		# Generate a new password for the root user and save it to /root/.my.cnf
		#passwd=`random_string 20`
		#mysqladmin -u root password "$passwd"
		
		#echo "MySQL password: $passwd"
		print_warn "MySQL root password is saved in /root/.my.cnf"

		cat > /root/.my.cnf <<END
[client]
user = root
password = $passwd
END
		chmod 600 /root/.my.cnf

		#invoke-rc.d mysql stop > /dev/null
		#service mysql stop > /dev/null

		#invoke-rc.d mysql start
		#service mysql start

		#service mysql restart

		# Full mysql permissions to root user
		#mysql -uroot -p$( printf "%q" "$passwd") -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$(printf "%q" "$passwd")' WITH GRANT OPTION; FLUSH PRIVILEGES;"

		#mysql -uroot -p$( printf "%q" "$passwd") -e "SHOW DATABASES;"

	else
		print_warn "Error installing MySQL"
	fi
fi
