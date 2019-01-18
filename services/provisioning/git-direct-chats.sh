#!/bin/sh -e

# Update package list and upgrade all packages
sudo yum -y update

# Install git
sudo yum -y install git

su - vagrant -c 'git clone https://github.com/meta-exception/scalable-n-restful.git --branch production'

su - vagrant -c 'cd scalable-n-restful/services/direct-chats && npm run vagrant-deploy'
