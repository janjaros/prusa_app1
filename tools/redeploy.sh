#!/bin/bash

[ "$(id -u)" -ne 0 ]&&echo "Please run as root"
[ -f ./env ]|| { echo "Must be run in directory git root and .env must exist and be correctly filled" ; exit; }

docker build -f docker/app/Dockerfile -t prusa_app  .
docker tag prusa_app localhost:5000/prusa_app
docker push localhost:5000/prusa_app

cd /apps/app1

docker stack deploy -c docker-compose-prod.yml prusa_app1