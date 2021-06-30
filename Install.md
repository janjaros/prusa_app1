# Prusa DevOps task

## Server preparation

In the confings/puppet folder are modules to configure the following:
* Create user `prusa_admin` with password less sudo, no password and user should be able connect via SSH with `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhPd7qHzXBp41QIhXz8HUBq6QjuyGanfXYVPzn9kM6w prusa_admin`
* Create user `prusa_non_admin` without sudo, no password and user should be able connect via SSH with `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBTg8KKBP/VbPH+VAYLqhGjCBoGBqNPj63BbTFP3Bov prusa_non_admin`
* Install basic packages `curl`, `wget`, `vim`, `nano`, `apache2-utils` and `jq`
* Install docker

Manually install nginx:

`sudo apt install curl gnupg2 ca-certificates lsb-release`

``echo "deb http://nginx.org/packages/debian `lsb_release -cs` nginx" 
    | sudo tee /etc/apt/sources.list.d/nginx.list``

``echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" 
    | sudo tee /etc/apt/preferences.d/99nginx``

``curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key``

``sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc``

``sudo apt update``

``sudo apt install nginx``

Install certbot:

``sudo apt install certbot python-certbot-nginx``

Install docker-compose:

``sudo pip3 install docker-compose``

It is used to easily start the database container and use the prepared compose file. 
Using database in a container is not the best practice, but I hope it is fine for 
this demostration purpose. Also a compose file is not needed but I consider it easier to read than an oneliner command
It would probably laso work as part of the stack but I am not sure how it would
behave with the named volumeand didn't want to risk it. 

Get letsencrypt certificate:

``certbot --nginx certonly -d prusa-ukol1.southgate.cz --rsa-key-size=4096``

Nginx configuration files are located in the configs/nginx folder. 
copy the default.conf to /etc/nginx/sites-enabled/default
copy the nginx.conf to /etc/nginx/nginx.con

Generate strong DH parameters:

``openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096``

Restart nginx:

``systemctl restart nginx``

Properly create .env variable based on .env.sample
Run the init script as root from the root of the git repo:

``bash tools/init.sh``

This script builds the app, starts local repository for docker, init the db, generates config
and also starts the app in a docker stack on port 8004.

Load balancing is done on the docker level. This allows also easy updating without a downtime.

In the setting there is set to have always 2 containers running. 
If updates is done, the containers are updated
one by one. 



If a change is done to the app or the image it can be redeployed with:

``bash tools/redeploy.sh``


## Comments

I have updated the requirements.txt to include also versions of the packages
1) It is not clear which version was used to write the base app. It can be a problem with apps like Django or Flask.
2) It can lead to unexpected behaviour if a package updates without the knowledge of the developer

There is a .gitlab-ci.yml file ready for gitlab to build and also run code-analysis and conde-safety check


Application endpoints are:
* `/` - hello world endpoint
* `/status` - status endpoint
* `/palindrom/<text>` - check if the text is palindrom, if true the text is stored in the DB
* `/admin` - admin area
* `/prepare-for-deploy` - prepare application for deployment
* `/ready-for-deploy` - confirms the app is ready for deployment
* `/redis-hits` - endpoint for testing redis connection
