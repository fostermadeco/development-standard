# -*- mode: ruby -*-

##### Ensure required plugins are installed

plugins = %w(
  vagrant-hostsupdater
  vagrant-triggers
  vagrant-disksize
)

plugins.keep_if { |plugin| not Vagrant.has_plugin? plugin }

if not plugins.empty?
  if system "vagrant plugin install #{plugins.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

####

if ['up', 'provision', 'reload'].include?(ARGV[0])
  unless system('ansible-playbook ansible/system_check/main.yml -i localhost,')
    raise 'System check failed'
  end
end

require 'yaml'

dir = File.dirname(File.expand_path(__FILE__))
vars = YAML.load_file("#{dir}/ansible/group_vars/all")
version = YAML.load_file(File.exist?("#{dir}/ansible/version") ? "#{dir}/ansible/version" : "#{dir}/ansible/roles/version")

Vagrant.configure("2") do |config|

  if (vars["trust_cert"] || 1) == 1
    certpath = vars['certpath'] || '/usr/local/etc'
    cert = certpath + "/ssl/certs/#{vars['hostname']}.crt"
    keychain = '/Library/Keychains/System.keychain'

    [:up, :provision, :reload].each do |command|
      if !File.exist?(certpath)
        config.trigger.before command do
          run "sudo mkdir -p #{certpath}"
          run "sudo chown #{`whoami`} #{certpath}"
        end
      end

      config.trigger.after command do
        system("sudo security verify-cert -c #{cert} > /dev/null 2>&1 || sudo security add-trusted-cert -d -k #{keychain} #{cert}")
      end
    end

    [:destroy].each do |command|
      if File.exist?(cert)
        config.trigger.after command do
          system("security find-certificate -ac #{vars['hostname']} -Z #{keychain} | awk -F: '/SHA-1 hash/{ print $2 }' | xargs -I {} sudo security delete-certificate -Z {} #{keychain}")
          File.delete(cert)
        end
      end
     end
  end

  config.vm.box = version
  config.disksize.size = '64GB'

  config.vm.hostname = vars["hostname"]
  config.vm.network "private_network", ip: vars["private_address"]

  config.hostsupdater.remove_on_suspend = false
  config.hostsupdater.aliases = [ "#{vars['email_hostname']}" ] + (vars['server_aliases'] || []) + (vars['additional_vhosts'] || [])

  config.ssh.username = "vagrant"
  config.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
  config.ssh.insert_key = false
  config.ssh.keys_only = false
  config.ssh.forward_agent = true

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
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
