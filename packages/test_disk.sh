#!/bin/bash

print_info "Classic I/O test"
print_info "dd if=/dev/zero of=iotest bs=64k count=16k conv=fdatasync && rm -fr iotest"
dd if=/dev/zero of=iotest bs=64k count=16k conv=fdatasync && rm -fr iotest
