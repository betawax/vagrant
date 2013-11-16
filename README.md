# Vagrant Stack

The Vagrant Stack I use for local PHP development, focused on the following tasks:

- Get up and running with Vagrant in minutes using a simple shell script
- Obtain the PHP version the project needs to rely on by simply specifing it
- Easily access the database from the host system

## Usage

Download the `Vagrantfile` and `bootstrap.sh` to your project directory:

	curl -O https://raw.github.com/betawax/vagrant-stack/master/Vagrantfile
	curl -O https://raw.github.com/betawax/vagrant-stack/master/bootstrap.sh

Open up the `Vagrantfile` and define your project name and the required PHP version:

	project_name = "foobar"
	php_version = "5.5"

Possible values of the `php_version` are `5.5`, `5.4` or `5.3`.

Now open up `bootstrap.sh` and adjust it to your needs.

And finally when you're done, start up Vagrant:

	vagrant up

## Access the guest system

By default, the `bootstrap.sh` will create a virtual host, a MySQL database and a database user based on the project name you defined in the `Vagrantfile`.

You can access the virtual host on your host system by simply adding it to your `/etc/hosts` file:

	10.10.10.10 foobar.dev

The MySQL database can be accessed from your host system by using the guest's IP address:

	mysql -h 10.10.10.10 -u foobar -pfoobar foobar

## License

Licensed under the MIT license.
