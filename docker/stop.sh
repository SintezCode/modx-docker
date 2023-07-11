#!/bin/bash

source "./.env"
#remove DOMAIN from hosts
#sudo sed -i "/${DOMAIN}/d" /etc/hosts

docker-compose stop
