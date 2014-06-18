simpleserversetup
=================

An easy way to automatically setup/provision a debian/ubuntu VPS or Vagrant development box. Built in Bash.

This is still in beta. While has been tested and works, it might not work perfectly yet.

To test it out from your local machine...

	git clone https://github.com/Xeoncross/simpleserversetup.git ./
	cp Vagrantfile-Sample Vagrantfile
	vagrant up
	vagrant ssh
	cd /vagrant
	sudo su
	./simpleserversetup sample-server

To run the same thing on a live VPS

	ssh root@192.168.1.1
	...
	git clone https://github.com/Xeoncross/simpleserversetup.git ./
	./simpleserversetup sample-server
