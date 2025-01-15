#container for mariaDB

FROM 	alpine:3.20

#RUN		apk update && apk add mariadb mariadb-client
RUN		apk update && apk add --no-cache mariadb
	
COPY	./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY	./tools/script.sh script.sh

EXPOSE	3306

CMD	["/bin/sh", "script.sh"]





