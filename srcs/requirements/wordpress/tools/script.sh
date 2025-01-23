#!/bin/bash

# Database configuration from secrets and environment variables
DB_NAME="${WORDPRESS_DB_NAME}"

# Read secrets from files 
if [ -f "${WORDPRESS_DB_USER_FILE}" ]; then
    DB_USER=$(cat "${WORDPRESS_DB_USER_FILE}")
else
    echo "Error: Missing or invalid WORDPRESS_DB_USER_FILE"
    exit 1
fi

if [ -f "${WORDPRESS_DB_PASSWORD_FILE}" ]; then
    DB_PASSWORD=$(cat "${MYSQL_PASSWORD_FILE}")
else
    echo "Error: Missing or invalid WORDPRESS_DB_PASSWORD_FILE"
    exit 1
fi

# Make sure WP can connect to MariaDB
echo "Waiting for MariaDB to be ready..."
echo "mariadb -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}""

while ! mariadb -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}"; do
	
	echo "MariaDB unavailable - retrying in 5 seconds ..."
	sleep 5
done

sleep 100
#exec /usr/sbin/php-fpm7.3 -F