#!bin/bash
sudo -i
yum install httpd -y
yum update -y
service httpd start
chkconfig httpd on
echo " <html><h1>Hello AWS Instance </h1><html> " > /var/www/html/index.html
