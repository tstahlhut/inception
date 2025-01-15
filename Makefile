# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tstahlhu <tstahlhu@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/08 11:55:53 by tstahlhu          #+#    #+#              #
#    Updated: 2025/01/14 12:46:54 by tstahlhu         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# make docker-compose run

# Install docker and docker compose

all:	up

install:
		sudo apt update 
		sudo apt install docker.io docker-compose -y

up:
#	@sudo docker-compose -f ./srcs/docker-compose.yml up  --build -d 
	@docker-compose -f ./srcs/docker-compose.yml up -d 
	
# -d let's it run in background
	

stop:
#	@sudo docker-compose -f ./srcs/docker-compose.yml stop
	@docker-compose -f ./srcs/docker-compose.yml stop

down:
#	@sudo docker-compose -f ./srcs/docker-compose.yml down
	
	@docker-compose -f ./srcs/docker-compose.yml down

list:
#	@sudo docker-compose -f ./srcs/docker-compose.yml ps
	
	@docker-compose -f ./srcs/docker-compose.yml ps