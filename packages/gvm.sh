#!/bin/bash

apt-get -qq install mercurial bison git mercurial bzr gcc golang-go golang-src > /dev/null 2>&1

# https://github.com/moovweb/gvm
if [[ $? == 0 ]]; then
	if [[ ! -e  ~/.gvm/scripts/gvm ]]; then
		bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
	fi
fi