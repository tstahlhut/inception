# Inception

A 42 project in which you use Docker and Docker-compose to host a Wordpress Website with Nginx, MariaDB and PHP.

"This project aims to broaden your knowledge of system administration by using Docker. You will virtualize several Docker images, creating them in your new personal virtual
machine." (from the subject)

## 42 Project - To Do

1. Makefile (at root dir): sets up entire application (i.e. builds Docker images using docker-compose.yml)

## VirtualBox

### Transfer Virtual Machine from one host machine to another

1. Export the VM:

	- Open VirtualBox on the source host.
	- Select the VM you want to transfer.
    - Go to File > Export Appliance.
    - Follow the prompts to create an OVA file (Open Virtual Appliance). This file packages the VM and its settings into a portable format.

2. Transfer the OVA File:

    Copy the OVA file to the target host machine. You can use a USB drive, network transfer, or cloud storage for this.

3. Import the VM on the Target Machine:

   - Open VirtualBox on the target host.
   - Go to File > Import Appliance.
   - Select the OVA file and follow the prompts to import it.

Start the VM:

    After importing, the VM should appear in your VirtualBox list. You can start it normally.


## Docker

### Docker Containers

To build a docker container you have to build or pull a docker image first. You can pull the image from Docker Hub:

	docker pull image_name

To download a special version, use the ":"

	docker pull image_name:version

For this project, however, you have to build all your docker images youself, except for Debian or Alpine.

### Write your own Dockerfile

A Dockerfile is a script that contains instructions for building a customized docker image. Each instruction in a Dockerfile (e.g. "FROM", "RUN", "COPY") creates a new layer in the image, and the final image is composed of all the layers stacked on top of each other.

#### 1. Create file

Create a new file and name it "Dockerfile".

#### 2. Instructions: FROM

	FROM <image>

**FROM** specifies the base image on which the container will be build. 

The base image is essentially the starting environment for the container. It could be an operating system (like Debian or Alpine) or a pre-built image tailored for specific use cases (like Node.js or Python images).

For example:

	FROM node:14-alpine3.16

This specifies the official Node.js image, version 14, built on top of the lightweight alpine Linux distribution version 3.16. It is a **pre-configured image**.

But there do not exist pre-configured images for all services. If you want to write your own dockerfile for nginx, you just specify the base image (e.g. alpine or debian) in "FROM" and then install nginx with the "RUN" instruction.

#### 3. Instructions: RUN

This is a command that is used in a Dockerfile to execute a command in the terminal of the container. It is typically used to install software or libraries that are needed by the application.

#### 4. Instructions: COPY

The COPY instruction in a Dockerfile is used to copy files or directories from your local host machine (the Docker build context) into the Docker image during the build process.

	COPY [source] [destination]


#### Sources for this Section

Source: [Medium article](https://medium.com/@anshita.bhasin/a-step-by-step-guide-to-create-dockerfile-9e3744d38d11)
[README by Forstman1](https://github.com/Forstman1/inception-42/tree/main)

and ChatGPT

### Run a Docker Container

Then you can run the docker image:

	docker run -d -t --name my_container pulled_image

To run the container you have options. The -p maps the port from the docker container to the host. First you specify the port of the host and then the port of the container:

	docker run -d -t -p hostport:containerport --name my_container pulled_image
	docker run -d -t -p 80:80 --name nginx nginx

To see your running containers, use:

	docker ps

To see memory usage and so forth:

	docker stats

In order to get inside a docker container you can you the docker command exec, e.g.:

	docker exec -it my_ubuntu_container bash

and you are inside your container using bash and can navigate through the file system of the docker container. To exit, just types

	exit

In order to stop a container from running, you just type:

	docker stop container_name

To restart the container:

	docker start container_name


### Docker Networks

#### Default Network

When running docker, docker has its own default network, a **bridge**: **172.17.0.0/16**. This allows all docker containers communicate with each other inside the network. Docker uses DNS and DHCP to set it all up.


#### User-defined Network 

However, it is better to set up your own bridge network, a **user-defined** bridge. This let's you, for example, ping other containers just by name which is awesome because ip addresses may change. In order to set up a user-defined network, simply run:

	sudo docker network create *network_name*

If you run

	ip address shown

you will see that a new bridge network has been created. If it is the first, it is most likely: 172.18.0.0/16

If you run 

	sudo docker network ls 

you will see your new network. *DRIVER* is in docker the network type.

When you want to run a container inside your new network, you just specify the network with **--network**:

	sudo docker run -itd --rm --network *network_name* --name *container_name* *image_name*

The container can only communicate with other containers inside the same network and not, for example, with containers inside the default network of docker.

If you want your container, e.g. nginx, to be reachable from outside, you have to map a port:

#### Host

If you run a docker container in the network *host*, it is in no docker network but just in the host network. This means that it runs as any normal application and is not isolated as docker containers are by default. Thus, you can just run nginx without configuring any ports.

	sudo docker run -itd --rm --network host --name webserver nginx

#### MACVLAN (bridge mode)

If you use MACVLAN as network in docker, the container acts as if it was a device directly connected to the home network, with its own MAC and IP address. 

In order to create a MACVLAN network, you have to 
1. define the driver (-d)
2. the subnet it should belong to (e.g. your home network)
3. the gateway of that subnet (e.g. your router)
4. tie the macvlan to our host network interface (find it by "ip address show")
5. give the macvlan a name

	sudo docker network create -d macvlan --subnet 10.7.1.0/24 --gateway 10.7.1.3 -o parent=enp0s31f6 my_macvlan

If you do not specify the ip address for your container, docker will choose one for you. But this may lead to conflicts, because it has no DHCP and will not check if that IP address is already in use. So, make sure to specify it yourself!

Check if the network was created:

	sudo docker network ls

Once you have your macvlan, you can run a container inside it. For this you have to assign the ip address for that container yourself. Make sure it is in the range of the macvlan network and that the ip address is available and not yet used by another device.

	sudo docker run -itd --rm --network my_macvlan --ip 10.7.1.92 --name webserv nginx

Now, the webserver is connected to the home network just like a regular virtual machine. 

However, you may encounter a problem. All containers in the macvlan network have their own MAC addresses but are connected to the same port on your switch (the one you specified with *parent*). This may lead to problems as often the computer can only handle one MAC address per port. You can deal with that problem by enabling promiscuous mode for your switch. If you are working on a virtual machine you can enable it in the settings ("Allow All"). In the terminal you can allow promiscuous mode for your port, by:

	sudo ip link set *interface* promisc on

	sudo ip link set enp0s31f6 promisc on

Now, it should work. However, you may not always have the permissions to do so. 

#### MACVLAN (802.1q trunked bridge mode)

So far, we have been using the MACVLAN in bridge mode. But there is another mode: 802.Iq mode. In this mode, docker creates the containers as individual interfaces.

1. create a new subnet
2. create a new gateway in that subnet
3. create a subinferface (docker will create the **sub**interface for you but the interface has to exist)

	sudo docker create network create -d macvlan --subnet 192.168.20.0/24 --gateway 192.168.20.1 -o parent=enp0s31f6.20 macvlan20

	ip address show

And you will see your new subinterface! Note: For this to work, you have to have trunking setup.

#### IPvlan (mode L2)

IPvlan in mode L2 is almost the same as MacVlan with the only difference being: the containers share the same MAC address as the host but have their very own IP addresses. This takes away the problem of promiscuity. Of course, there could be problems with one MAC address having several IP addresses but in most cases this should be fine and work. 

L2 is the default mode of IPvlan.

To create it type: 

	sudo docker network create -d ipvlan --subnet 10.7.1.0/24 --gateway 10.7.1.3 -o parent=enp0s31f6 ipvlan

Add containers and do not forget to assign them an ip address!

	sudo docker run -itd --rm --network ipvlan --ip 10.7.1.92 --name webserver nginx

Test it by pinging from the container to the gateway:

	sudo docker exec -it webserver share

		ping 10.7.1.3

And from your host machine to the container:

	ping 10.7.1.92

#### IPvlan (mode L3)

IPvlan in L3 mode is functioning on layer 3, i.e. Ip addresses, routing, etc.

In this mode, the containers are connected to the host like it was a router. This means that there is no broadcast traffic.

Create the new network:
1. give a range for the subnet
2. do not specify a gateway because it will be the parent interface we will connect it to
3. specify L3 mode
4. create another network (if you wish to): you have to create all the networks you want to have going through your gateway at the same time.

	sudo docker network create -d ipvlan --subnet 194.168.94.0/24 -o parent=enp0s31f6 -o ipvlan_mode=l3 --subnet 192.168.95.0/24 ipvlanl3

Now, you can assign your containers to it. If you have several networks, you have to specify to which it should belong by specifying the ip address. Otherwise, you do not need to give it an ip adress.

	docker run -itd --rm --network ipvlanl3 --ip 192.168.94.7 --name webserv1 nginx
	docker run -itd --rm --network ipvlanl3 --ip 192.168.95.8 --name webserv2 nginx

Webserv1 and webserv2 can ping each other even though they are on different networks. But as they share the same interface as gateway, it works :) 

What does not work, however, is for them to ping the internet. For it to work, you have to add static routes to your routing table, so that the containers can reach the internet and vice versa. 

## Docker compose

Install docker and docker compose:

	sudo apt update
	sudo apt install docker.io docker-compose -y

To run nginx in a container, you would normally do:

	sudo docker run --name nginx -itd -p 8080:80 nginx

With docker compose, you simply write these instructions into a docker-compose file. Name it **docker-compose.yaml**:

	version: "3"	(docker version)
	services:
		nginx:
			image: nginx
			ports:
				- "8080:80"
			restart: always

Mind the tabs in the beginning, they are important!

The docker-compose file should be in its own directory. If not, you have to add some specifications.
Then run the docker-compose file (optionally with "-d" to run it in the background):

	sudo docker-compose up

By default, docker-compose creates the container(s) and the network. In order to stop all containers created by docker-compose, type:

	sudo docker-compose stop

To inquire about them (and only the docker-compose containers):

	sudo docker-compose ps

And to delete them fully, as well as the created network, type:

	sudo docker-compose down

#### Simple Docker-Compose Example File

	version: '3'    # Defines the version of Docker Compose file format
	services:       # List of services (containers)
		service_name: # Name of the service/container
			image: image_name:tag   # The Docker image to use
			ports:                 # Expose ports
			- "host_port:container_port"
			environment:           # Environment variables
			- KEY=value
			volumes:               # Volumes to mount
			- ./local_path:/container_path
			networks:              # Define networks if needed
			- network_name


## NGINX

in easy words, Nginx is a webserver, i.e. a HTTP(S) server. More precisely, Nginx is a reverse proxy and can act as a load balancer. This means that Nginx is prefixed to the actual servers and forwards requests to an available server. 


From:
[Youtube Video by Laith Academy](https://www.youtube.com/watch?v=7VAI73roXaY)

### Installation on Ubuntu

In the terminal:

	sudo apt update
	sudo apt install nginx

Test if the installation was successfull by typing "localhost" in your webbrowser. If you see the following, it was successfull:

	Welcome to nginx!
	[...]

From: [Canonical](https://ubuntu.com/tutorials/install-and-configure-nginx#2-installing-nginx)


### Nginx with Docker

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


### Terminology

Contex: A code block

	events {
	worker_connections 768;
	# multi_accept on;
	}

Directives: key and value

	worker_connections 768;

### Configure Nginx

In order to configure Nginx, you change the contents of the config file.

	cd /etc/nginx

Open the file "nginx.conf". You can even delete its content and rewrite it from scratch. At minimum the config file should contain an events context and a http context in which the port is specified and the directory in which the (html) files are which should be served.

	nginx.conf

	http {
		server {
			listen 8080;
			root /usr/me/myfiles;
		}
	}

	events {}

After having configured the config file, you have to reload nginx:

	nginx -s reload

You can check if the configuration is ok by running:

	nginx -t

#### Mimes

The basic config file shown above works well for plain html text. If you want to style it, however, (include style.css file in your directory) or add pictures etc to your website, you have to add a types context:

	types {
		text/css	css;
		text/html	html;
		[...]
	}

All these types are already given in nginx, namely in **mime.types**.

So, instead of typing the types ourselves, we can include the mime.types file in the http context:

	http {

		include mime.types;

		server {
			listen 8080;
			root /usr/me/myfiles;
		}
	}


#### Location 

In order to add other index.html sides, you can add a location in server context of the config file:

	server {
			listen 8080;
			root /usr/me/myfiles;

			location /about {
				root /usr/me/myfiles;
			}
		}

Nginx appends autmatically the specified location ("/about") to the speicified root path.

If you do not want nginx to append the location automatically, you can write *alias* instead of *root*. In this case, you have to specify the whole path:

	server {
			listen 8080;
			root /usr/me/myfiles;

			location /about {
				alias /usr/me/myfiles/info;
			}
		}

By default, nginx looks for a index.html file. If the directory contains more files, you want to display, you can specify so by using *try_files*:


	server {
			listen 8080;
			root /usr/me/myfiles;

			location /about {
				root /usr/me/myfiles;
				try_files /about/me.html /index.html =404;
			}
		}

Nginx looks for the files from left to right. If /usr/me/myfiles/about/me.html does not exist, it will look for /usr/me/myfiles/index.html, if that does not exist, it will return a 404 Page not found error. 

If you want to serve one page for several locations, you can so by:

	location ~* /about/[0-9] {
				root /usr/me/myfiles;
				try_files /lexicon.html =404;
			}

The URLs ending with about/0, about/1, etc will all work and display the same webpage: lexicon.html.


#### Redirects

	location /info {
		return 307 /about
	}

This context redirects thanks to the HTTP code 307 to the about location.

Be aware, that the displayed URL will in that case be ../about and not the requested ../info. So, each time you request ../info, you get ../about.

#### Rewrite

If you want to serve the content of the about file but not change the URL as in the redirect example, you can rewrite it. 

	rewrite ^/about/(\w+) /info/$1;

	location ~* /about/[0-9] {
				root /usr/me/myfiles;
				try_files /lexicon.html =404;
			}

Requesting ../info/5 will result in displaying lexicon.html (i.e. about/5)
 but at the same time the URL will stay ../info/5.

#### Load Balancer

If you want nginx to load balance between different backend servers, you can do so, too, by manipulating the config file. First, you have to name the IP addresses and ports the servers are running on and then you have to forward it to the servers by *proxy_pass* which uses the round robin algorithm to balance the load.

	upstream backendserver {
		server 127.0.0.1:1111;
		server 127.0.0.1:1112;
		server 127.0.0.1:1113;
		server 127.0.0.1:1114;
	}

	server {
		listen 8080;
		root /usr/me/myfiles;

		location / {
			proxy_pass http://backendserver;
		}
		[...]
	}


Resources:
[Youtube Video by Laith Academy](https://www.youtube.com/watch?v=7VAI73roXaY)


### TLSv1.2 and TLSv1.3

TLSv1.2 (released in 2008) and TLSv1.3 (released in 2018) are versions of the **Transport Layer Security (TLS)** protocol, which is used to secure communication over the internet. TLS ensures privacy, data integrity, and authentication when you connect to websites, APIs, or other services.

#### What is TLS?

TLS (Transport Layer Security) is the successor to the now-obsolete SSL (Secure Sockets Layer) protocol. It is used in:

 -   HTTPS (secure HTTP)
 -   Securing emails (SMTP, IMAP, POP)
 -  VPNs and other secure connections.

#### Configure TLS for Nginx

1. Open your NGINX configuration file, e.g., /etc/nginx/nginx.conf or /etc/nginx/conf.d/default.conf.

2. Add or modify the following directives in your server block:

	server {
		listen 443 ssl;

		# SSL certificate and private key
		ssl_certificate /path/to/server.crt;
		ssl_certificate_key /path/to/server.key;

		# Enable only TLSv1.2 and TLSv1.3
		ssl_protocols TLSv1.2 TLSv1.3;

		# Use secure ciphers
		ssl_ciphers HIGH:!aNULL:!MD5;

		# Other SSL optimizations
		ssl_prefer_server_ciphers on;
		ssl_session_cache shared:SSL:10m;
		ssl_session_timeout 10m;
	}
