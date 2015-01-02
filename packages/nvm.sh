#!/bin/bash

# https://github.com/creationix/nvm
if [[ ! -e  ~/.nvm ]]; then
	curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

	# Reload bash file to make nvm available
	source ~/.bashrc
	# source ~/.nvm/nvm.sh

	nvm install 0.10
	nvm use 0.10
fi