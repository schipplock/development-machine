Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.disksize.size = '15GB'  
  config.vm.provision "file", source: "vm_scripts", destination: "$HOME/vm_scripts"
  config.vm.provision "shell", path: "provision.sh"
  config.vm.network "public_network", bridge: "enp0s31f6"

  config.vm.provider "virtualbox" do |v|
    v.name = "development-machine"
    v.memory = 4048
    v.cpus = 4
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
  end
end
