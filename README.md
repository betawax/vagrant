# Vagrant Stack

Vagrant LAMP Stack for local PHP development.

✔︎ Get up and running with Vagrant in minutes by using a shell script for provisioning  
✔︎ Hassle free project setup with a pre-configured private network and synced folder  
✔︎ Easy access to the guest database from your host system, e.g. via Sequel Pro  

**Operating System**

🚀 Ubuntu Server 14.04 LTS (Trusty Tahr)

**Main Technologies**

🚀 PHP 7.3 🚀 MySQL 5.7 🚀 Apache 2.4 🚀 Postfix 🚀 OpenSSL

**Also Included**

🚀 Composer 🚀 NPM

## Usage

1. Place the `Vagrantfile` and `bootstrap.sh` into your project directory
2. Open up the `Vagrantfile` and adjust the few configuration properties

	```
	project_slug  = "foobar"      # Will be used to name the guest database etc.
	document_root = "public"      # Your document root, e.g. public or web
	vm_ip_address = "10.10.10.10" # The guest's private network IP address
	```

3. Get Vagrant up and running

	```
	vagrant up
	```

## Access the guest system

By default, the provisioning script will create two Virtual Hosts (HTTP & HTTPS), a MySQL database and a database user, all named after the project slug you previously defined in the `Vagrantfile`.

To access the Virtual Hosts in your browser, add the guest's IP address and your project slug to your `/etc/hosts` file:

```
10.10.10.10 foobar.local
```

To access the MySQL database from your host system, again use the guest's IP address and your project slug:

```
mysql -h 10.10.10.10 -u foobar foobar -pfoobar
```

## License

Licensed under the MIT license.
