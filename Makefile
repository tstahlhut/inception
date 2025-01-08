# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tstahlhu <tstahlhu@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/08 11:55:53 by tstahlhu          #+#    #+#              #
#    Updated: 2025/01/08 16:01:59 by tstahlhu         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# make docker-compose run

# Install docker and docker compose

all:	up

install:
		sudo apt update 
		sudo apt install docker.io docker-compose -y

up:
	@docker-compose -f ./srcs/docker-compose.yml up -d 
	
# -d let's it run in background
	

stop:
	@docker-compose -f ./srcs/docker-compose.yml stop

down:
	@docker-compose -f ./srcs/docker-compose.yml down

list:
	@docker-compose -f ./srcs/docker-compose.yml ps