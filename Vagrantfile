# -*- mode: ruby -*-

require 'yaml'

dir = File.dirname(File.expand_path(__FILE__))
vars = YAML.load_file("#{dir}/ansible/group_vars/all")
version = YAML.load_file("#{dir}/ansible/roles/version")

Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')

Vagrant.configure("2") do |config|

  if vars["trust_cert"] == 1
    [:up, :provision].each do |command|
      if !File.exist?(vars['certpath'])
        config.trigger.before command do
          run "sudo mkdir -p #{vars['certpath']}"
          run "sudo chown #{`whoami`} #{vars['certpath']}"
        end
      end

      config.trigger.after command do
        run "sudo security add-trusted-cert -d -k '/Library/Keychains/System.keychain' #{vars['certpath']}/ssl/certs/#{vars['hostname']}.crt"
      end
    end
  end

  config.vm.box = version

  config.vm.hostname = vars["hostname"]
  config.vm.network "private_network", ip: vars["private_address"]

  config.hostsupdater.remove_on_suspend = false
  config.hostsupdater.aliases = [ "#{vars['email_hostname']}" ] + (vars['server_aliases'] || []) + (vars['additional_vhosts'] || [])

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = true
  config.ssh.keys_only = false
  config.ssh.forward_agent = true

  config.vm.synced_folder ".", "/var/www/#{vars['hostname']}", type: "nfs"

  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.memory = 1024
    virtualbox.cpus = 2
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/provision.yml"
  end

end
