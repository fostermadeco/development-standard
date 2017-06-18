# -*- mode: ruby -*-

require 'yaml'

system('./provision.sh')

dir = File.dirname(File.expand_path(__FILE__))
vars = YAML.load_file("#{dir}/ansible/group_vars/all")

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end

  config.vm.box = vars["version"]

  config.vm.network "private_network", ip: vars["private_address"]

  config.hostsupdater.remove_on_suspend = false

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = true
  config.ssh.keys_only = false
  config.ssh.forward_agent = true

  hostnames = vars["hosts"].map{|host| host["hostname"]}
  config.hostsupdater.aliases = hostnames

  vars["hosts"].each do |host|
    config.vm.synced_folder "#{host['path']}", "#{host['web_root']}", type: "nfs"
  end

  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.memory = 1024
    virtualbox.cpus = 2
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/provision.yml"
  end

end