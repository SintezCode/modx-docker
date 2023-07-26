#!/bin/bash

#TODO if .env file not exists generate it on .env.dist with random variables or with interactive questions if option -i existed

source "./.env"
NAME=${COMPOSE_PROJECT_NAME}-php-fpm
#Copy .env file
cp .env ../assets/.env
cp .env ../modx/.env

#TODO Add DOMAIN to hosts
#Add DOMAIN to hosts
#sudo sed -i "1s;^;127.0.0.1    ${DOMAIN}\n;" /etc/hosts
#C:\Windows\System32\drivers\etc\hosts

# Foreground mode
# docker-compose up --build

# Background mode
docker-compose up --build --detach

docker exec -t $(docker ps --filter name=$NAME -q) bash -c "composer install"

$SHELL
