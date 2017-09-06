#!bin/bash
yum install httpd -y
systemctl start httpd.service
echo " <html><h1>Hello AWS Instance </h1><html> " > /var/www/html/index.html
