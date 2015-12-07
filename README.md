# Vagrant Stack

A Vagrant LAMP Stack for local PHP development, focused on the following tasks:

- Get up and running with Vagrant in minutes by using a shell script for provisioning
- Simple configuration of environment properties like PHP version and web server
- Easy access to the guest database from the host system, e.g. via Sequel Pro

## Usage

Download the `Vagrantfile` and `bootstrap.sh` to your project directory:

```
curl -O https://raw.githubusercontent.com/betawax/vagrant-stack/master/Vagrantfile
curl -O https://raw.githubusercontent.com/betawax/vagrant-stack/master/bootstrap.sh
```

Now open up the `Vagrantfile` and define the environment properties for your project:

```
project_name  = "foobar" # Shortcut, no spaces etc.
php_version   = "5.6"    # 5.6, 5.5, 5.4 or 5.3
web_server    = "apache" # apache or nginx
document_root = "public" # e.g. public or web
```

The project name shortcut will be used to name the project directory and database. Optionally you can also change the IP address of the virtual machine that will be used as your database host.

Next you can open up the `bootstrap.sh` and adjust it to your needs, or leave everything as it is for a default LAMP environment.

And finally when you're done, start up Vagrant:

```
vagrant up
```

## Access the guest system

By default, the `bootstrap.sh` will create a virtual host, a MySQL database and a database user based on the project name shortcut you defined in the `Vagrantfile`.

You can access the virtual host on your host system by simply adding it to your `/etc/hosts` file:

```
10.10.10.10 foobar.dev
```

The MySQL database can be accessed from your host system by using the guest's IP address:

```
mysql -h 10.10.10.10 -u foobar -pfoobar foobar
```

## Resources

- [Laravel Homestead provision script](https://github.com/laravel/settler/blob/master/scripts/provision.sh)
- [Laravel Homestead nginx server config](https://github.com/laravel/homestead/blob/master/scripts/serve.sh)
- [Vaprobash pro​visioning scripts](https://github.com/fideloper/Vaprobash)

## License

Licensed under the MIT license.
