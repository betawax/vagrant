project_name  = "foobar"
php_version   = "5.6"
web_server    = "apache"
document_root = "public"
ip_address    = "10.10.10.10"

Vagrant.configure("2") do |config|
  
  config.vm.box = "hashicorp/precise32"
  config.vm.hostname = project_name
  config.vm.network :private_network, ip: ip_address
  config.vm.synced_folder "./", "/var/www/#{project_name}", owner: "vagrant", group: "www-data", mount_options: ["dmode=775,fmode=664"]
  config.vm.provision :shell, path: "bootstrap.sh", :args => "Vagrant #{project_name} #{php_version} #{web_server} #{document_root}"
  
  #config.vm.provision :shell, inline: "echo '#{project_name}' > /etc/hostname && hostname '#{project_name}'"
  #config.vm.synced_folder "./", "/var/www/#{project_name}", type: "nfs"
  
end
