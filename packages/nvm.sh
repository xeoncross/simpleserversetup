#!/bin/bash

# https://github.com/creationix/nvm
if [[ ! -e  ~/.nvm ]]; then
	curl https://raw.githubusercontent.com/creationix/nvm/master/nvm.sh | bash

	nvm install 0.10
	nvm use 0.10
fi