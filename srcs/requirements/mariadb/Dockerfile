#container for mariaDB

FROM 	alpine:3.20

RUN		apk update && apk upgrade && \
		apk add mariadb mariadb-client tini

	
COPY	./conf/mariadb_custom.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY	./tools/init.sql /etc/mysql/init.sql
COPY	./tools/init.sh /tmp/init-mariadb.sh

RUN		chmod 755 /tmp/init-mariadb.sh /etc/mysql/init.sql

EXPOSE	3306

ENTRYPOINT ["/sbin/tini", "--"]

# Run MariaDB configuration script 
CMD	["/tmp/init-mariadb.sh" ]



