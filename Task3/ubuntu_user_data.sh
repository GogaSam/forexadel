#!/bin/bash
sudo apt -y update
sudo apt -y install apache2
OS_VERSION=$(cat /proc/version)
cat <<EOF > /var/www/html/index.html
<html>
<h2 align=center> Hello World!</h2><br>
<p align=center>$OS_VERSION</p>
</html>
EOF
sudo systemctl start apache2
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerdio
sleep 80
curl -i 10.0.1.154