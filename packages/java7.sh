#!/bin/bash

# Oracle Java 7
# @todo check for install first!

add-apt-repository -y ppa:webupd8team/java

print_warn "Updating Package List"
apt-get -qq update --assume-yes
print_success "Package List Updated"

Install the latest stable version of Oracle Java 7 with this command (and accept the license agreement that pops up):

apt-get -y -qq --assume-yes install oracle-java7-installer > /dev/null