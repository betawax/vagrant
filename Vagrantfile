project_name = "foobar"
php_version = "5.5"

ip_address = "10.10.10.10"

Vagrant.configure("2") do |config|
  
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  
  config.vm.network :private_network, ip: ip_address
  config.vm.synced_folder "./", "/var/www/#{project_name}", owner: "www-data", group: "www-data"
  
  config.vm.provision :shell, path: "bootstrap.sh", :args => "#{project_name} #{php_version}"
  
end
