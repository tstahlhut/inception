#!/bin/bash

DIRPATH='/var/www/html'

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

chmod 755 $DIRPATH

# Download WordPress Command Line Interface (WP-CLI)
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

# Download Wordpress core files as root
./wp-cli.phar core download --allow-root --path=$DIRPATH

# Create wp-config.php
./wp-cli.phar config create --allow-root --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --path=$DIRPATH

# Install Wordpress (admin user, set up database tables)
./wp-cli.phar core install --allow-root --url=localhost --title=$TITLE --admin_user=$DB_USER --admin_email:tstahlhu@student.42berlin.de --admin_password=$DB_PASSWORD --path=$DIRPATH



php-fpm7.4 -F