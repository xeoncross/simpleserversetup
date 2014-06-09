#!/bin/bash

if apt-get -s install wget > /dev/null; then
	print_warn "Network test"
	echo "wget cachefly.cachefly.net/100mb.test -O 100mb.test && rm -fr 100mb.test"
	wget cachefly.cachefly.net/100mb.test -O 100mb.test && rm -fr 100mb.test
else
	print_error "Please install wget first"
fi