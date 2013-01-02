# Vagrant setup for Atlassian Stash

http://www.atlassian.com/software/stash/overview

## Install with

- Install Vagrant: http://www.vagrantup.com

- Execute:

    vagrant box add base http://files.vagrantup.com/precise32.box

    git clone https://github.com/durdn/spinu12.git stash

    cd stash

    git co -b stash origin/stash
    
    vagrant up
    
## Enjoy with

    cd /vagrant

    STASH_HOME=/vagrant/stash-home /vagrant/atlassian-stash-2.0.1/bin/start-stash.sh

Access local browser at http://localhost:7990/setup
