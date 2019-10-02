Vagrant.configure("2") do |config|

config.vm.box = "sbeliakou/centos"

 	config.vm.define "nginx" do |nginx|
	nginx.vm.hostname = "NGINX"
	nginx.vm.network "private_network", ip: "192.168.56.238"
	nginx.vm.provision :shell, path: "nginx.sh"
	nginx.vm.provider "virtualbox" do |vb|
   	 vb.name="NGINX"
  	 vb.memory = "1024"
      	end
    end
 end	