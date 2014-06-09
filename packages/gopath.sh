#!/bin/bash

if [[ ! -d ~/Go/ ]]; then
	echo "export GOPATH=~/Go" >> ~/.profile
	mkdir -p ~/Go/{bin/,pkg/,src/}
fi
