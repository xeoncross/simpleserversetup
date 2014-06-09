#!/bin/bash

print_warn "Classic I/O test"
echo "dd if=/dev/zero of=iotest bs=64k count=16k conv=fdatasync && rm -fr iotest"
dd if=/dev/zero of=iotest bs=64k count=16k conv=fdatasync && rm -fr iotest
