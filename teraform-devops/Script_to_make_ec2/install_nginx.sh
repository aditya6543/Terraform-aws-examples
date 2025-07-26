#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1>this is a normal html page that proves nginx is installed correctly</h1>" | sudo tee /var/www/html/index.html