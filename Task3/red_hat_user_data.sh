#!/bin/bash
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y update
sudo yum -y install nginx
sudo nginx -v
OS_VERSION=$(cat /proc/version)
sudo cat <<EOF > /usr/share/nginx/html/index.html
<html>
<h2 align=center> Hello World!</h2><br>
<p align=center>$OS_VERSION</p>
</html>
EOF
sudo nginx
curl -I 127.0.0.1