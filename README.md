# Development Standard

Base files for provisioning a standard development environment.

## What will this do for me?

After following the steps outlined below, your fellow devs will be able to clone a repo and have a fully functional development environment simply by running `vagrant up`.

## Features

* Dev box IP address automatically added to `hosts` file.
* Local `https`-enabled website with automatic `http` redirects (relativize those asset URLs!).
* MailHog listens for mail on port 1025 with the web interface available on port 8025 (outbound traffic on ports 25 and 587 is disabled as an extra precaution).

## Prerequisites

1. VirtualBox — https://www.virtualbox.org/wiki/Downloads
2. Vagrant  — https://www.vagrantup.com/downloads.html
3. Vagrant hostsupdater plugin — `vagrant plugin install vagrant-hostsupdater`
4. Vagrant triggers plugin — `vagrant plugin install vagrant-triggers`
5. Homebrew — `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"` (Homebrew is not required if you truly prefer to use the system-installed Python and install Pip on your own).  
6. Python — `brew install python`
7. Ansible — `pip install ansible`

## Creating a new project

1. Download and copy the files from this repo (except for this README) into the project folder — do not clone the repo.
2. In the project root, run `git submodule add git@github.com:fostermadeco/ansible-roles.git ansible/roles`
3. Set your project variables in `ansible/group_vars/all`.
4. When `vagrant up` provisions the development machine to your satisfaction, make the initial commit.

## Ansible roles

Because this set up uses Vagrant’s Ansible provisioner, the full power of Ansible to use to add any additional project-specific requirements — feel free to modify `provision.yml` as much as you wish. However, if you feel that the addition would be useful in other projects, consider contributing it to the internal Ansible roles repo.  

## Provisioning

If a change is made to the configuration file, the provisioner can be run with the command `vagrant provision`. 

The provisioner can also be triggered with the ansible playbook command. The `--tags` flag can be used to allow you to run a specific part of the configuration, rather than running through the entire provisioning process.

`ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory ansible/provision.yml --tags "php_modules"`

## Etc.

Because the private IP addresses for dev boxes will now be under source control, there is an internal registry of dev hostnames and addresses. This is currently just a Google spreadsheet (https://docs.google.com/spreadsheets/d/1muC1u3OhrVKdCSPz-BC3NtK0I2HvWWhJ5gV9MgBEmSk), but it may become something more fancy in the future. The addresses start at 192.168.202.101, so pre-existing conflicts should be minimal.

The submodule may need to be initilized when pulling down a project with the submodule `git submodule update --remote` or `git submodule update --init ansible/roles`.

## Available Config

These items are configurable in `ansible/group_vars/all`:

`hostname` - This will be the hostname and virtualhost servername. It should end with `.dev`.

`private_address` - This is the private address. Grab the next available from the Google spreadsheet.

`public_dir` - This is the public directory inside the app.

`document_root` - This creates a document root var from the var in `public_dir`. This is typically set to `/var/www/{{ hostname }}/{{ public_dir }}`.

`php_modules` - Add all required PHP modules to this list.

`php_version` (7.0) - Used to override the default php version setting.

`mysql_databases` - Specify one or more databases to be created.

`packages` - List of apt packages.

`php_config` - List of php config items to be overrriden. The `section` value will default to `PHP`, which is the correct section most of the time. Use the `section` option the overide the section if it will not be `PHP`.

	php_config:
	  - option: "memory_limit"
	    value: "256M"
	  - option: "date.timezone"
	    section: "Date"
	    value: "UTC"
    
`mysql_config` - List of mysql config items to be overrriden. The `section` value will default to `mysqld`, which is the correct section most of the time. Use the `section` option the overide the section if it will not be `mysqld`.

	mysql_config:
	  - option: "key_buffer_size"
	    value: "24M"
	  - option: "socket"
	    section: "mysql_safe"
	    value: "/var/run/mysqld/mysql.sock"
