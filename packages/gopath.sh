#!/bin/bash

# This sets the gopath relative to your account
if [[ ! -d ~/Go/ ]]; then
	echo "export GOPATH=~/Go" >> ~/.profile
	mkdir -p ~/Go/{bin/,pkg/,src/}
	source ~/.profile
fi
