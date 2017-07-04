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
4. Homebrew — `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"` (Homebrew is not required if you truly prefer to use the system-installed Python and install Pip on your own).  
5. Python — `brew install python`
6. Ansible — `pip install ansible`

## Creating a new project

1. Download and copy the files from this repo (except for this README) into the project folder — do not clone the repo.
2. Add the ansible-roles submodule. There are multiple branches to choose from. In the project root, run `git submodule add -b BRANCH-OF-YOUR-CHOICE git@github.com:fostermadeco/ansible-roles.git ansible/roles`
  - `master` uses bento/ubuntu-16.04 (PHP7 and MySQL 5.7)
  - `trusty` uses ubuntu/trusty64 (PHP5 and MySQL 5.6)

3. Set your project variables in `ansible/group_vars/all`.
4. When `vagrant up` provisions the development machine to your satisfaction, make the initial commit.

> Note: By default, running `vagrant up` provisions your development environment as a LAMP stack. If you are working on Python/Django, in provision.yml under roles comment out `- lamp` and uncomment `- django`.

> For the time being, after the box has been provisioned, please follow these additional steps:
```
- ssh into the box
- run 'source bin/activate' in the project directory
- create the project by running 'django-admin startproject [your-project-name]'
- as root restart supervisor 'supervisorctl restart all'
```

## Working on an existing project
When working on an existing project you will need to re-initialize the submodules. After cloning the project run the following command in the project root: `git submodule update --init ansible/roles`. Read the project's README to determine which environment variables are set and make changes to `ansible/group_vars/all` then run `vagrant up`.

## Ansible roles

Because this set up uses Vagrant’s Ansible provisioner, the full power of Ansible to use to add any additional project-specific requirements — feel free to modify `provision.yml` as much as you wish. However, if you feel that the addition would be useful in other projects, consider contributing it to the internal Ansible roles repo.  

## Provisioning

If a change is made to the configuration file, the provisioner can be run with the command `vagrant provision`.

The provisioner can also be triggered with the ansible playbook command. The `--tags` flag can be used to allow you to run a specific part of the configuration, rather than running through the entire provisioning process.

`ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory ansible/provision.yml --tags "php_modules"`

## Etc.

Because the private IP addresses for dev boxes will now be under source control, there is an internal registry of dev hostnames and addresses. This is currently just a Google spreadsheet (https://docs.google.com/spreadsheets/d/1muC1u3OhrVKdCSPz-BC3NtK0I2HvWWhJ5gV9MgBEmSk), but it may become something more fancy in the future. The addresses start at 192.168.202.101, so pre-existing conflicts should be minimal.

The submodule may need to be initilized when pulling down a project with the submodule ```git submodule update --remote```.
