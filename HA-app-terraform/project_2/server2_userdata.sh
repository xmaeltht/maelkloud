#!/bin/bash
yum update -y
yum install httpd -y
echo '<html><body><h1 style="color:Red;">Welcome to Image Server 2 (Red)</h1></body></html>' > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
