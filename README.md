simpleserversetup
=================

An easy way to automatically setup/provision a debian/ubuntu VPS or Vagrant development box. Built in Bash.

Includes pre-made install scripts for modern applications not included in the package management system. For example, installing GVM or compiling nginx with openresty and drizzle.

Inside the `servers/` directory there is a sample server (my-sample-server) you can use to create your own recipes. Simply create a new folder and add a `packages.txt` file.


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
