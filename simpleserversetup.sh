#!/bin/bash

function print_warn {
	echo -n -e '\e[1;33m'; echo -n $1; echo -e '\e[0m'
}

function print_success {
	echo -n -e '\e[1;32m'; echo -n $1; echo -e '\e[0m'
}

function print_error {
	echo -n -e '\e[1;31m'; echo -n $1; echo -e '\e[0m'
}

function exit_error {
	print_error $1 && exit 1
}

#clear && 
print_success "SimpleServerSetup v0.0.1"

if [[ $(whoami) != "root" ]]; then
	exit_error "Please run as root"
fi

if [[ ! -f /etc/debian_version ]]; then
	exit_error "You must be running debian or ubuntu to use this"
fi


config_directory=${1%/} # trim the ending slash
VPS_Base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VPS_Base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VPS_Bits=$([[ $(uname -m) == *"64" ]] && echo "64" || echo "32")
VPS_CPU=$(grep "^physical id" /proc/cpuinfo | sort -u | wc -l)
VPS_CPU_Cache=$(grep "^cache size" /proc/cpuinfo | sort -u | awk '{ print int($4 / 1024) }')
VPS_CPU_Cores=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)
VPS_OS=$(lsb_release -si | awk '{ print tolower($0) }')
VPS_OS_Codename=$(lsb_release -sc | awk '{ print tolower($0) }')
VPS_RAM=$(grep "^MemTotal:" /proc/meminfo | awk '{ print int($2 / 1024) }')
VPS_HOSTNAME=$(uname -n)

print_warn "$VPS_OS $VPS_OS_Codename - '$VPS_HOSTNAME'"
print_warn "$VPS_CPU x $VPS_Bits bit CPU (with $VPS_CPU_Cores cores) and $VPS_RAM RAM"
echo ""

# Make sure this directory exists!
if [[ ! -d $VPS_Base/$config_directory ]]; then
	exit_error "Invalid Path '$config_directory'"
fi

print_warn "You must use a SINGLE tab (\t) to separate values in your package.txt"

# One last confirm from the user
if [[ ! $2 ]]; then
	echo "Do you wish to install from '$config_directory?'"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) break;;
			No ) exit;;
		esac
	done
fi

# Move to the temp directory for the rest of the session
# (Must use $VPS_Base to get the path back to these files now)
cd /tmp
#echo $VPS_Base

# Before we get started, lets define some helper functions
function random_string() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

function get_domain_name() {
	# Getting rid of the lowest part.
	domain=${1%.*}
	lowest=`expr "$domain" : '.*\.\([a-z][a-z]*\)'`
	case "$lowest" in
	com|net|org|gov|edu|co|me|info|name)
		domain=${domain%.*}
		;;
	esac
	lowest=`expr "$domain" : '.*\.\([a-z][a-z]*\)'`
	[ -z "$lowest" ] && echo "$domain" || echo "$lowest"
}

# Run apt-get install for the given package and set the result to $install_result
#function install {
#	install_result = `apt-get -qq --assume-yes install $config_directory > /dev/null`
#}

#function check_install {
#	return apt-get -s install $config_directory > /dev/null
#}

print_warn "Updating Package List"

# Update the package list first...
apt-get -qq update --assume-yes

print_success "Package List Updated"
print_warn "Checking Packages"

# If we have a list of packages to install
if [[ -f $VPS_Base/$config_directory/packages.txt ]]; then
	
	# Split each line into an array of parameters by tab
	while IFS=$'\t' read -r -a params
	do
		#echo $VPS_Base/$config_directory/packages/${params[0]}.sh
		#echo $VPS_Base/packages/${params[0]}.sh

		# @todo We already installed this
		#[[ -d "/etc/${params[0]}" ]] && continue;
		#if [ ! -z "`which "$1" 2>/dev/null`" ]; then
		#	continue;
		#fi

		# A custom install script for this package?
		[[ -f $VPS_Base/$config_directory/packages/${params[0]}.sh ]] && continue;

		# A standard install script for this package?
		[[ -f $VPS_Base/packages/${params[0]}.sh ]] && continue;

		echo "Checking ${params[0]} ${params[1]}"

		# A required version number?
		if [[ ${params[1]} ]]; then
			if ! apt-get -s install "${params[0]}=${params[1]}" > /dev/null
			then
				exit_error "Aborting Install"
			fi

		# As long as it is avaiable
		else 
			if ! apt-get -s install ${params[0]} > /dev/null
			then
				exit_error "Aborting Install"
				#echo "error"
			fi
		fi

	done < $VPS_Base/$config_directory/packages.txt
	# ./basic_dialog.sh  filename.txt
fi


print_success "Package Checks Complete"
print_warn "Starting Install"


# Allow the system to be modified before we start
if [[ -f $VPS_Base/$config_directory/pre_install.sh ]]; then
	source $VPS_Base/$config_directory/pre_install.sh
fi

# If we have a list of packages to install
if [[ -f $VPS_Base/$config_directory/packages.txt ]]; then
	
	# Split each line into an array of parameters by tab
	while IFS=$'\t' read -r -a params
	do
		#echo $VPS_Base/$config_directory/packages/${params[0]}.sh
		#echo $VPS_Base/packages/${params[0]}.sh

		# A custom install script for this package?
		if [[ -f $VPS_Base/$config_directory/packages/${params[0]}.sh ]]; then
			source $VPS_Base/$config_directory/packages/${params[0]}.sh

		# A standard install script for this package?
		elif [[ -f $VPS_Base/packages/${params[0]}.sh ]]; then
			source $VPS_Base/packages/${params[0]}.sh

		# A required version number?
		elif [[ ${params[1]} ]]; then
			
			if [ -z "`which "$params{0}" 2>/dev/null`" ]; then
				apt-get -qq --assume-yes install "${params[0]}=${params[1]}" #> /dev/null

				if [[ $? != 0 ]]; then
					exit_error "Something went wrong installing '${params[0]} ${params[1]}'."
				fi
			else 
				print_warn "${params[0]} is already installed"
			fi

		# As long as it is avaiable
		else 
			

			if [ -z "`which "$params{0}" 2>/dev/null`" ]; then
				apt-get -qq --assume-yes install "${params[0]}" #> /dev/null

				if [[ $? != 0 ]]; then
					exit_error "Something went wrong installing '${params[0]}'."
				fi
			else 
				print_warn "${params[0]} is already installed"
			fi


			#apt-get -qq --assume-yes install ${params[0]} #> /dev/null

			#if [[ $? != 0 ]]; then
			#	exit_error "Something went wrong installing '${params[0]}'."
			#fi
		fi

	done < $VPS_Base/$config_directory/packages.txt
fi


print_success "Package Installs Complete"

# If there is an install script, run that too!
if [[ -f $VPS_Base/$config_directory/post_install.sh ]]; then
	source $VPS_Base/$config_directory/post_install.sh
fi


print_success "Setup Complete"

exit 0

# If you do not see the package version you want, try this:
# http://jaqque.sbih.org/kplug/apt-pinning.html

