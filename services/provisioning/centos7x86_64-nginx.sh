#!/bin/sh -e

# Update package list and upgrade all packages
sudo yum -y update

# Add
sudo rpm -Uvh https://nginx.org/packages/mainline/centos/7/x86_64/RPMS/nginx-1.15.8-1.el7_4.ngx.x86_64.rpm

# Install
sudo yum -y install nginx

# https://stackoverflow.com/questions/49597942/load-balancer-on-nginx-give-502-bad-gateway
setsebool -P httpd_can_network_connect 1

sudo echo -e "
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    upstream backend_hosts {
        server 10.1.0.2:8080;
        server 10.1.0.3:8080;
    }

    server {
        listen 8080;

        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
        add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';

        location / {
            proxy_pass http://backend_hosts;
        }
    }
}
" > /etc/nginx/nginx.conf

sudo systemctl enable nginx

sudo systemctl restart nginx
#        server 10.1.0.4;
