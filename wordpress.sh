#!/bin/bash
#install-wordpress-centos7.sh
#
# Description: This script will download, configure and install WordPress for CentOS/RHEL 7.x Linux.
#
cd /opt
 
# Open firewall ports
firewall-cmd --permanent --zone=public --add-service=http 
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
 
# Install the database
yum -y install mariadb-server httpd php php-mysql
systemctl enable mariadb.service
systemctl start mariadb.service
 
# Add to the database
echo 'CREATE DATABASE wordpress;' | mysql
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'172.31.31.123' IDENTIFIED BY 'ctrls@123';" | mysql
echo "FLUSH PRIVILEGES;" | mysql
 
# Download and install WordPress
curl -O https://wordpress.org/latest.tar.gz
tar -C /var/www/html/ --strip-components=1 -zxvf latest.tar.gz && rm -f latest.tar.gz
cd /var/www/html
mkdir wp-content/{uploads,cache}
chown apache:apache wp-content/{uploads,cache}
 
# Configure WordPress
cp wp-config-sample.php wp-config.php
sed -i 's@database_name_here@wordpress@' wp-config.php
sed -i 's@username_here@wordpress@' wp-config.php
sed -i 's@password_here@password@' wp-config.php
curl https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
 
# Modify the .htaccess
echo "# BEGIN WordPress
<IfModule mod_rewrite.c> 
   RewriteEngine On 
   RewriteBase / 
   RewriteRule ^index\.php$ - [L] 
   RewriteCond %{REQUEST_FILENAME} !-f 
   RewriteCond %{REQUEST_FILENAME} !-d 
   RewriteRule . /index.php [L] 
</IfModule> 
# END WordPress" >> .htaccess
chmod 666 /var/www/html/.htaccess
 
# Configure and start Apache
sed -i "/^<Directory \"\/var\/www\/html\">/,/^<\/Directory>/{s/AllowOverride None/AllowOverride All/g}" /etc/httpd/conf/httpd.conf
systemctl enable httpd.service
systemctl start httpd.service
