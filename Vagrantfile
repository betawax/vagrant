project_slug  = "foobar"
document_root = "public"
vm_ip_address = "10.10.10.10"

Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = project_slug
  config.vm.network :private_network, ip: vm_ip_address
  
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end
  
  config.vm.synced_folder "./", "/var/www/#{project_slug}", owner: "vagrant", group: "www-data", mount_options: ["dmode=775,fmode=664"]
  config.vm.provision :shell, path: "bootstrap.sh", :args => "Vagrant #{project_slug} #{document_root}"
  
  #config.vm.synced_folder "./", "/var/www/#{project_slug}", type: "nfs"
  #config.vm.provision :shell, inline: ""
  
end
