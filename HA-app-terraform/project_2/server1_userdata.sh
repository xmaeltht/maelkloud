#!/bin/bash
yum update -y
yum install httpd -y
echo '<html><body><h1 style="color:Blue;">Welcome to Image Server 1 (Blue)</h1></body></html>' > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
