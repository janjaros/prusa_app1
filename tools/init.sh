#!/bin/bash
set -ex
[ "$(id -u)" -ne 0 ]&&echo "Please run as root"
[ -f ./env ]|| { echo "Must be run in directory git root and .env must exist and be correctly filled" ; exit; }
cp .env tools/prusa_app_other/
cd tools/prusa_app_other/
export $(cat .env | sed 's/#.*//g' | xargs)
docker-compose up -d --no-deps db
docker-compose up -d --no-deps registry
cd ../../
docker build -f docker/app/Dockerfile -t prusa_app  .
docker tag prusa_app localhost:5000/prusa_app
docker push localhost:5000/prusa_app
cd tools/prusa_app_other/
docker-compose run --rm app python3 /home/docker/src/create_db.py

mkdir -p /apps/app1
cd ../../
cat docker-compose-prod.yml | sed "s/_PASSWORD_/${DB_PASSWORD}/g" |  sed "s/_IP_/${DB_IP}/g"  |  sed "s/_PORT_/${DB_PORT}/g" |  sed "s/_DB_NAME_/${DB_NAME}/g" > /apps/app1/docker-compose-prod.yml
cd /apps/app1
docker swarm init
docker stack deploy -c docker-compose-prod.yml prusa_app1

ADMIN_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-8};echo;)
htpasswd -b -c /etc/nginx/admin_area developer "${ADMIN_PASS}"
systemctl restart nginx
echo "Admin area pass for developer: ${ADMIN_PASS}"




