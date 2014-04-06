# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "precise64"

    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    config.vm.network :forwarded_port, guest: 80, host: 8080

    config.vm.network :private_network, :ip => "10.0.1.106"

    config.vm.provision :shell, :path => "install.sh"

    config.vm.hostname = "hhvm.local"

    config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=666"]

    config.ssh.forward_agent = true
end