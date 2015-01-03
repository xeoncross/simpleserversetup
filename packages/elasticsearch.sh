#!/bin/bash

# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html

# @todo check for install first!

wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
sudo add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main"

print_warn "Updating Package List"
apt-get -qq update --assume-yes
print_success "Package List Updated"

apt-get -qq --assume-yes install elasticsearch > /dev/null

# Configure Elasticsearch to automatically start during bootup
sudo update-rc.d elasticsearch defaults 95 10

# Installed to /usr/share/elasticsearch/bin/elasticsearch