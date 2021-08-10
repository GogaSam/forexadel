#!/bin/bash
sudo yum -y update
sudo yum -y install epel-release 
sudo yum -y install nginx
OS_VERSION=$(cat /proc/version)
cat <<EOF > /var/www/html/index.html
<html>
<h2 align=center> Hello World!</h2><br>
<p align=center>$OS_VERSION</p>
</html>
EOF
sudo nginx