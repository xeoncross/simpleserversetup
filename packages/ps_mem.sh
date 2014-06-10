#!/bin/bash

if [[ ! -e /usr/local/sbin/ps_mem ]]; then
	wget -q https://raw.github.com/pixelb/ps_mem/master/ps_mem.py -O /usr/local/sbin/ps_mem && chmod +x /usr/local/sbin/ps_mem
fi