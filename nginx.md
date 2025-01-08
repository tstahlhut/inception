# inception
A 42 project in which you use Docker and Docker-compose to host a Wordpress Website with Nginx, MariaDB and PHP.


## Nginx

When you use Docker, you do not need to install Nginx separately but can just download all the necessary components for the container with the following command:

	docker pull nginx

In order to create a new container for nginx, you use the command "run". With --name you can specify the name of the container and with -p the port on which it should run (80: maps the port of the container and :80 the port of the server).

	docker run --name docker-nginx -p 80:80 nginx

(Does not work for me!)

To see the status of the containers, type:

	docker ps -a

And to remove a container, simply type

	docker rm [name of container]

into the terminal.


From:
https://www.digitalocean.com/community/tutorials/how-to-run-nginx-in-a-docker-container-on-ubuntu-22-04

