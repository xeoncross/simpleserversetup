#!/bin/bash

if apt-get -s install $1 > /dev/null; then
	print_info "Network test"
	print_info "wget cachefly.cachefly.net/100mb.test -O 100mb.test && rm -fr 100mb.test"
	wget cachefly.cachefly.net/100mb.test -O 100mb.test && rm -fr 100mb.test
else
	print_error "Please install wget first"
fi