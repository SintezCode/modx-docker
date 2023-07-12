#!/bin/bash

source "./.env"
#TODO remove DOMAIN from hosts
#remove DOMAIN from hosts
#sudo sed -i "/${DOMAIN}/d" /etc/hosts

docker-compose stop
