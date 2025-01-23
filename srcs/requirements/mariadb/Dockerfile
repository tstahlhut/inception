#container for mariaDB

FROM 	alpine:3.20

#RUN		apk update && apk add mariadb mariadb-client
RUN		apk update && apk upgrade && \
		apk add mariadb mariadb-client 
	#	apk add tini


	
COPY	./conf/mariadb_custom.cnf /etc/my.cnf.d/mariadb-server.cnf
#COPY	./tools/script.sh script.sh
#COPY	./tools/init.sql /docker-entrypoint-initdb.d
COPY	./tools/init.sql /etc/mysql/init.sql
COPY	./tools/init.sh /tmp/init-mariadb.sh

RUN		chmod 755 /tmp/init-mariadb.sh /etc/mysql/init.sql

EXPOSE	3306

#ENTRYPOINT ["/usr/bin/tini", "--"]

# Run MariaDB configuration script 
CMD	["/tmp/init-mariadb.sh" ]



