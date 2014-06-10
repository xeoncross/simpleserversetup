simpleserversetup
=================

An easy way to automatically setup/provision a debian/ubuntu VPS or Vagrant development box. Built in Bash.


This is still in development!

Unless you know bash - I probably would wait a bit because it might not work perfectly yet.

To test it out from your local machine...

	git clone https://github.com/Xeoncross/simpleserversetup.git ./
	cp Vagrantfile-Sample Vagrantfile
	vagrant up
	vagrant ssh
	cd /vagrant
	sudo su
	./simpleserversetup.sh default-server
