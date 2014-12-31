## My Simple Server

This is a package list for a fictitious server that installs a bunch of common tools and all the packages provided by install scripts with SimpleServerSetup.

To use this with your own network you would create your own folders for each server type and place your own `packages.txt` file inside them.

After you create your server configs, it's simple to provision new machines.

	ssh root@my-simple-server
	...
	git clone https://github.com/Xeoncross/simpleserversetup.git ./
	./simpleserversetup my-sample-server

Done!