#!/bin/bash

#See https://www.digitalocean.com/community/tutorials/how-to-create-a-ssl-certificate-on-nginx-for-ubuntu-12-04 
sudo openssl genrsa -des3 -out server.key 1024
# funinthesun
sudo openssl req -new -key server.key -out server.csr
# Common Name: 9.70.82.136 
# Common Name: pquiringubuntu
sudo cp server.key server.key.org
sudo openssl rsa -in server.key.org -out server.key 

sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
