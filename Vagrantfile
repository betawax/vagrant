project_name = "foobar"
php_version  = "5.6"
web_server   = "apache"
ip_address   = "10.10.10.10"

Vagrant.configure("2") do |config|
  
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  
  config.vm.hostname = project_name
  #config.vm.provision :shell, inline: "echo '#{project_name}' > /etc/hostname && hostname '#{project_name}'"
  config.vm.network :private_network, ip: ip_address
  config.vm.synced_folder "./", "/var/www/#{project_name}", owner: "vagrant", group: "www-data", mount_options: ["dmode=775,fmode=664"]
  #config.vm.synced_folder "./", "/var/www/#{project_name}", type: "nfs"
  
  config.vm.provision :shell, path: "bootstrap.sh", :args => "Vagrant #{project_name} #{php_version} #{web_server}"
  
end
