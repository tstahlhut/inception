# wordpress container

FROM	debian:buster-slim

RUN		apt-get update && apt-get install -y \
		wget \
	#	unzip \
	#	git for wordpress plugins
# php:
# core php runtime
		php7.3 \
# to serve php files via fastcgi for nginx
		php7.3-fpm \
# communication with mariadb
		php7.3-mysql \ 
# required for parsing XML data (RSS feeds)
#		php7.3-xml \
# proper handling of UTF-8 (multilanguage)
#		php7.3-mbstring
# for HTTP requests (plugin/theme updates and REST API calls)
#		php7.3-curl
		#mariadb-client \
		&& apt-get clean

RUN		wget https://wordpress.org/wordpress-6.7.1.tar.gz -P /var/www \
		&& cd /var/www \
		&& tar -xvzf wordpress-6.7.1.tar.gz \
		&& rm wordpress-6.7.1.tar.gz 

RUN		chown -R root:root /var/www/wordpress

#COPY	./conf/php.conf /etc/php/7.3/fpm/pool.d/www.conf

EXPOSE	9000

#CMD		["php-fpm7.3", "-F"]

