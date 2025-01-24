# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tstahlhu <tstahlhu@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/08 11:55:53 by tstahlhu          #+#    #+#              #
#    Updated: 2025/01/24 12:37:07 by tstahlhu         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# make docker-compose run

# Install docker and docker compose

all:	bup

install:
		sudo apt update 
		sudo apt install docker.io docker-compose -y

build:
#	@docker-compose -f ./srcs/docker-compose.yml build --no-cache
	LOGIN=tstahlhu DATA_PATH=/home/tstahlhu/data DOMAIN=tstahlhu.42.fr docker-compose -f ./srcs/docker-compose.yml up -d --build
bup:
	@if [ ! -d "/home/tstahlhut/data/wordpress" ]; then \
		echo "Creating /home/tstahlhut/data/wordpress"; \
		cd ~ && mkdir -p data/wordpress && chmod 777 data/wordpress; \
	fi
	@if [ ! -d "/home/tstahlhut/data/mariadb" ]; then \
		echo "Creating /home/tstahlhut/data/mariadb"; \
		cd ~ && mkdir -p data/mariadb && chmod 777 data/mariadb; \
	fi
	@docker-compose -f ./srcs/docker-compose.yml up --build -d

up:
#	@sudo docker-compose -f ./srcs/docker-compose.yml up -d 
	@docker-compose -f ./srcs/docker-compose.yml up -d 
	
# -d let's it run in background
	

stop:
	@sudo docker-compose -f ./srcs/docker-compose.yml stop
#	@docker-compose -f ./srcs/docker-compose.yml stop

down:
#	@sudo docker-compose -f ./srcs/docker-compose.yml down
	
	@docker-compose -f ./srcs/docker-compose.yml down

clearall:
	@docker-compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans
	yes | rm -r /home/tstahlhu/data
list:
#	@sudo docker-compose -f ./srcs/docker-compose.yml ps
	
	@docker-compose -f ./srcs/docker-compose.yml ps -a