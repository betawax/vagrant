# Vagrant Stack

This is the Vagrant Stack I use for local PHP development, it's focused on the following tasks:

- Get up and running with Vagrant in minutes by using a simple shell script
- Obtain the PHP version and web server that the project needs to rely on by simply specifying it
- Easily access the database from the host system, e.g. via Sequel Pro

## Usage

Download the `Vagrantfile` and `bootstrap.sh` to your project directory:

	curl -O https://raw.githubusercontent.com/betawax/vagrant-stack/master/Vagrantfile
	curl -O https://raw.githubusercontent.com/betawax/vagrant-stack/master/bootstrap.sh

Next open up the `Vagrantfile` and define a project name shortcut, your prefered web server and the PHP version to use:

	project_name = "foobar"
	php_version  = "5.6"
	web_server   = "apache"

The project name shortcut will be used to name the project directory and database. Possible values for the PHP version are `5.6`, `5.5`, `5.4` or `5.3`. Supported web servers are `apache` and `nginx`. Optionally you can also change the IP address of the virtual machine that will be used as your database host.

Now you can open up `bootstrap.sh` and adjust it to your needs, or leave everything as it is for a default LAMP environment.

And finally when you're done, start up Vagrant:

	vagrant up

## Access the guest system

By default, the `bootstrap.sh` will create a virtual host, a MySQL database and a database user based on the project name shortcut you defined in the `Vagrantfile`.

You can access the virtual host on your host system by simply adding it to your `/etc/hosts` file:

	10.10.10.10 foobar.dev

The MySQL database can be accessed from your host system by using the guest's IP address:

	mysql -h 10.10.10.10 -u foobar -pfoobar foobar

## License

Licensed under the MIT license.
