#!/bin/sh -e

# Edit the following to change the version of PostgreSQL that is installed
PG_V=11

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  exit
fi

# Update package list and upgrade all packages
sudo yum -y update

# Install PostgreSQL
sudo rpm -Uvh https://yum.postgresql.org/${PG_V}/redhat/rhel-7-x86_64/pgdg-centos${PG_V}-${PG_V}-2.noarch.rpm
sudo yum -y install postgresql${PG_V}-server postgresql${PG_V}

sudo /usr/pgsql-${PG_V}/bin/postgresql-${PG_V}-setup initdb

sudo systemctl enable postgresql-${PG_V}.service

PG_CONF="/var/lib/pgsql/${PG_V}/data/postgresql.conf"
PG_HBA="/var/lib/pgsql/${PG_V}/data/pg_hba.conf"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

sed -i "s/local   all             all                                     peer/local   all             all                                     trust/" "$PG_HBA"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Restart so that all new config is loaded:
sudo systemctl restart postgresql-${PG_V}

# Tag the provision time:
date > "$PROVISIONED_ON"

echo "Successfully created PostgreSQL virtual machine."
exit
