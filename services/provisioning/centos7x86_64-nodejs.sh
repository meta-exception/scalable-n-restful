#!/bin/sh -e

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  exit
fi

# Update package list and upgrade all packages
sudo yum -y update

# Code below belong to script from:
# https://rpm.nodesource.com/setup_10.x
# Convenient usage is:
# Install Node.JS 10 LTS # https://github.com/nodesource/distributions#rpm
# curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
# But also pipe to shell isn't good idea, so
# >>>
sudo rpm -Uvh https://rpm.nodesource.com/pub_10.x/el/7/x86_64/nodejs-10.15.0-1nodesource.x86_64.rpm
# <<<

sudo yum -y install nodejs

# Build tools to compile and install native modules:
#sudo yum install gcc-c++ make

# Tag the provision time:
date > "$PROVISIONED_ON"

echo "Successfully created Node.JS virtual machine."
exit
