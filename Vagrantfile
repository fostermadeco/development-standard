# -*- mode: ruby -*-

require 'yaml'

dir = File.dirname(File.expand_path(__FILE__))
vars = YAML.load_file("#{dir}/ansible/group_vars/all")
version = YAML.load_file("#{dir}/ansible/roles/version")

Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')

Vagrant.configure("2") do |config|

  if (vars["trust_cert"] || 1) == 1
    [:up, :provision].each do |command|
      certpath = vars['certpath'] || "/usr/local/etc"
      if !File.exist?(certpath)
        config.trigger.before command do
          run "sudo mkdir -p #{certpath}"
          run "sudo chown #{`whoami`} #{certpath}"
        end
      end

      config.trigger.after command do
        run "sudo security add-trusted-cert -d -k '/Library/Keychains/System.keychain' #{certpath}/ssl/certs/#{vars['hostname']}.crt"
      end
    end
  end

  config.vm.box = version

  config.vm.hostname = vars["hostname"]
  config.vm.network "private_network", ip: vars["private_address"]

  config.hostsupdater.remove_on_suspend = false
  config.hostsupdater.aliases = [ "#{vars['email_hostname']}" ]

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = true
  config.ssh.keys_only = false
  config.ssh.forward_agent = true

  config.vm.synced_folder ".", "/var/www/#{vars['hostname']}", type: "nfs", :nfs => true, :mount_options => ['actimeo=2']

  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.memory = 1024
    virtualbox.cpus = 2
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "ansible/provision.yml"
  end

end
