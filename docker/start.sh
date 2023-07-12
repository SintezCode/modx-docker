#!/bin/bash

#TODO if .env file not exists generate it on .env.dist with random variables or with interactive questions if option -i existed

source "./.env"
#Copy .env file
cp .env ../assets/.env

#TODO Add DOMAIN to hosts
#Add DOMAIN to hosts
#sudo sed -i "1s;^;127.0.0.1    ${DOMAIN}\n;" /etc/hosts
#C:\Windows\System32\drivers\etc\hosts

# Foreground mode
# docker-compose up --build

# Background mode
docker-compose up --build --detach
