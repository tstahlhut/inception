# penultimate version of debian as of jan/2025

FROM		debian:bullseye

RUN			apt update && apt upgrade -y && \
			apt install -y php7.4-fpm php7.4-mysql curl tini default-mysql-client && \
			mkdir -p /run/php && chown www-data:www-data /run/php


COPY		./conf/php.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY		./tools/init.sh /tmp/config-script.sh

RUN			chmod +x /tmp/config-script.sh

WORKDIR		/var/www/html

ENTRYPOINT	["/usr/bin/tini", "--"]

CMD			["/tmp/config-script.sh"]