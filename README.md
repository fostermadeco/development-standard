# Development Standard

Base files for provisioning a standard development environment

## Prerequisites

1. VirtualBox — https://www.virtualbox.org/wiki/Downloads
2. Vagrant  — https://www.vagrantup.com/downloads.html
3. Vagrant hostsupdater plugin — `vagrant plugin install vagrant-hostsupdater`
4. Homebrew — `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"` (Homebrew is not required if you truly prefer to use the system-installed Python and install Pip on your own).  
5. Python — `brew install python`
6. Ansible — `pip install ansible`

## Creating a new project

1. Download and copy the files from this repo (except for this README) into the project folder — do not clone the repo.
2. In the project root, run `git submodule add git@github.com:fostermadeco/ansible-roles.git ansible/roles`
3. Set your project variables in `ansible/group_vars/all`.
4. When `vagrant up` provisions the development machine to your satisfaction, make the initial commit.
5. Any additions to the Ansible roles submodule should be committed to its repo.
