# wordpress container

FROM	debian:buster-slim

RUN		apt-get update && apt-get install -y \
	#	wordpress \
		wget \
	#	unzip \
	#	git for wordpress plugins
# php:
# core php runtime
		php7.3 \
# to serve php files via fastcgi for nginx
		php7.3-fpm \
# communication with mariadb
		php-mysql \ 
# required for parsing XML data (RSS feeds)
		php7.3-xml \
# proper handling of UTF-8 (multilanguage)
		php7.3-mbstring \
# for HTTP requests (plugin/theme updates and REST API calls)
		php7.3-curl \
		mariadb-client \
		&& apt-get clean

RUN		wget https://wordpress.org/wordpress-6.7.1.tar.gz -P /var/www/html \
		&& cd /var/www/html \
		&& tar -xvzf wordpress-6.7.1.tar.gz \
		&& rm wordpress-6.7.1.tar.gz 

RUN		chown -R www-data:www-data /var/www/html

COPY	./conf/php.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY	./tools/script.sh /tmp/config-script.sh
COPY	./conf/wp-config.php /var/www/html/wordpress/wp-config.php

WORKDIR	/var/www/html/wordpress

EXPOSE	9000

CMD		["/tmp/config-script.sh"]

