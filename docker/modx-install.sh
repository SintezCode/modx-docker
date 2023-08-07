#!/bin/bash

source "./.env"
NAME=${COMPOSE_PROJECT_NAME}-php-fpm

docker exec -t $(docker ps --filter name=$NAME -q) bash -c "gitify modx:download $MODX_VERSION"

docker exec -t $(docker ps --filter name=$NAME -q) bash -c "mkdir -p /modx/${MODX_PUBLIC_DIR}"
docker exec -t $(docker ps --filter name=$NAME -q) bash -c "mv /modx/manager/ /modx/${MODX_PUBLIC_DIR}${MODX_MGR_DIR}"
docker exec -t $(docker ps --filter name=$NAME -q) bash -c "mv /modx/connectors/ /modx/${MODX_PUBLIC_DIR}${MODX_CONNECTORS_DIR}"
docker exec -t $(docker ps --filter name=$NAME -q) bash -c "mv /modx/config.core.php /modx/${MODX_PUBLIC_DIR}"
docker exec -t $(docker ps --filter name=$NAME -q) bash -c "mv /modx/ht.access /modx/${MODX_PUBLIC_DIR}"
docker exec -t $(docker ps --filter name=$NAME -q) bash -c "mv /modx/index.php /modx/${MODX_PUBLIC_DIR}"

if [ $MODSTORE_API_KEY ]; then
    printf $MODSTORE_API_KEY > ../modx/.modstore.pro.key
fi

:'
if [ $YANDEX_MAP_API_KEY ]; then
    mkdir -p "../modx/_data/packages_settings/"
    printf "key: yandex_coords_tv_api_key
value: $YANDEX_MAP_API_KEY
namespace: yandexcoordstv
area: api" > ../modx/_data/packages_settings/yandex-coords-tv-api-key.yaml
fi
'

docker exec -t $(docker ps --filter name=$NAME -q) bash -c "php setup/cli-install.php --database_server=mariadb \
  --database=$MARIADB_DATABASE --database_user=$MARIADB_USERNAME --database_password=$MARIADB_PASSWORD \
  --table_prefix=$MODX_TABLE_PREFIX --language=$MODX_LANGUAGE --cmsadmin=$MODX_ADMIN_LOGIN --cmspassword=$MODX_ADMIN_PWD --cmsadminemail=$MODX_ADMIN_EMAIL \
  --context_mgr_path=/modx/${MODX_PUBLIC_DIR}${MODX_MGR_DIR} --context_mgr_url=/$MODX_MGR_DIR \
  --context_connectors_path=/modx/${MODX_PUBLIC_DIR}${MODX_CONNECTORS_DIR} --context_connectors_url=/$MODX_CONNECTORS_DIR \
  --context_web_path=/modx/$MODX_PUBLIC_DIR --http_host=$DOMAIN"

docker exec -t $(docker ps --filter name=$NAME -q) bash -c "cp /modx/${MODX_PUBLIC_DIR}config.core.php /modx/"

./modx-restore.sh

docker exec -t $(docker ps --filter name=$NAME -q) bash -c "gitify package:install --all"

docker exec -t $(docker ps --filter name=$NAME -q) bash -c "php post-install.php"

$SHELL
