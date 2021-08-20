#!/bin/bash
echo "<html><h2>Goga Samunashvili Sandbox 2021!<br>$DEVOPS</h2><html>" > /var/www/html/index.html
/usr/sbin/apache2ctl -DFOREGROUND