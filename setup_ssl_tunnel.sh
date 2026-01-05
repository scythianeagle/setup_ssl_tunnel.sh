#!/bin/bash

# Update system and install necessary packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y openssh-server stunnel4

# Generate self-signed SSL certificate
country=US
state=New_York
locality=New_York
organization=atc
organizationalunit=tower
commonname=emam
email=twr.buz@gmail.com
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/stunnel/stunnel.key -out /etc/stunnel/stunnel.crt -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

# Create a stunnel configuration file
sudo touch /etc/stunnel/stunnel.conf
sudo tee -a /etc/stunnel/stunnel.conf > /dev/null <<EOT
cert = /etc/stunnel/stunnel.crt
key = /etc/stunnel/stunnel.key

[ssh]
accept = 444
connect = 127.0.0.1:1899
EOT

# Enable stunnel service
sudo sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/stunnel4

# Restart stunnel service
sudo systemctl restart stunnel4

echo "SSL tunnel setup completed!"
