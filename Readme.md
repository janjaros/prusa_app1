# Prusa DevOps task

## Summary

We have simple python [REST app](#rest-application). We would like to build docker container and run the app behind load balancer. The site should be accessible via HTTPS and some endpoints shouldn't be accessible from the internet.

The result of this task should be GIT repository with required files to allow us replicate the setup. Please use some reasonable format (markdown, wiki, ansible, puppet, bash script, ...) and add readme with introduction into the repository.

## Tasks
### Prepare the server
* Create user `prusa_admin` with password less sudo, no password and user should be able connect via SSH with `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhPd7qHzXBp41QIhXz8HUBq6QjuyGanfXYVPzn9kM6w prusa_admin`
* Create user `prusa_non_admin` without sudo, no password and user should be able connect via SSH with `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBTg8KKBP/VbPH+VAYLqhGjCBoGBqNPj63BbTFP3Bov prusa_non_admin`
* Install basic packages `curl`, `wget`, `vim`, `nano`and`jq`

### Dockerize the application
* Build the docker image of the application
* Prepare the DB (postgresql, mysql or mariadb) for the application with 2 users one user with full access for application and second  read-only user `developer`
* Start 2 containers with the application
* Deploy redis container and interconnect application containers with it
* The containers should start/restart automatically unless the container is stopped

### Loadbalancing and SSL
* Place the containers behind load balancer and balance traffic between them
* Everything should be available via HTTPS, HTTP should be automatically redirected to the HTTPS. Use self-signed or let's encrypt SSL certificate.
* `/admin` endpoint is behind basic auth protection, create one user `developer` with some password
* `/prepare-for-deploy` and `/ready-for-deploy` endpoint are blocked on load balancer

### Redeploy script
* Prepare the script we can use for release new version of the application
* Build new docker image with the application
* Stop containers with old version and start newones
* Try to do it without visible outage on loadbalancer

### Other
* Use opensource tools
* Use technologies of your choice
* Let us know in case of any questions

## REST application

The application is simple python3 flask-based REST app. All requirements are in `requirements.txt`. Application needs connection for the database for single endpoint. You can control the application configuration via ENV variables:

```
APP_HOST=0.0.0.0
APP_PORT=5000
REDIS_HOST=redis
REDIS_PORT=6379
DATABASE_URI=sqlite:////tmp/test.db
DATABASE_URI=mysql+pymysql://user:password@host:3306/db_name
DATABASE_URI=postgresql+psycopg2://user:password@host:5432/db_name
```

The application can be used with commands

```
python create_db.py # create DB
python drop_db.py # drop DB
python app.py # Run application
```

Application endpoints are:
* `/` - hello world endpoint
* `/status` - status endpoint
* `/palindrom/<text>` - check if the text is palindrom, if true the text is stored in the DB
* `/admin` - admin area
* `/prepare-for-deploy` - prepare application for deployment
* `/ready-for-deploy` - confirms the app is ready for deployment
* `/redis-hits` - endpoint for testing redis connection

The application is ready once the `/status` is responding with `200` message `OK`. Not ready state results in `404` message `Not ready`.

You should wait on `/ready-for-deploy` with response `200` message `Ready` before you stop the application (lets pretend there are some async tasks in background which need to be completed).

### Notes

DB drivers `pymysql` and `psycopg2` are part of the `requirements.txt`, change them in case you have some problem with installation.
DB will fallback on `sqlite:////tmp/test.db`, you still have to create the structure via `create_db.py`
