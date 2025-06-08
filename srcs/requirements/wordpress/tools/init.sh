#!/bin/bash
mkdir -p /run/php
chown www-data:www-data /run/php

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
    DB_PASSWORD=$(cat "${WORDPRESS_DB_PASSWORD_FILE}")
else
    echo "Error: Missing or invalid WORDPRESS_DB_PASSWORD_FILE"
    exit 1
fi

echo "Waiting for MariaDB to be ready..."

until mysqladmin ping -h"mariadb" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
  echo "MariaDB not ready yet..."
  sleep 5
done

echo "MariaDB is ready!"


chmod 755 $WP_DIR

# Download WordPress Command Line Interface (WP-CLI)
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

# Download Wordpress core files as root
./wp-cli.phar core download --allow-root --path=$WP_DIR

# Create wp-config.php
./wp-cli.phar config create --allow-root --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --path=$WP_DIR

# Install Wordpress (admin user, set up database tables)
./wp-cli.phar core install --allow-root --url=$DOMAIN --title=$TITLE --admin_user=$DB_USER --admin_email=tstahlhu@student.42berlin.de --admin_password=$DB_PASSWORD --path=$WP_DIR

# Turn off comment moderation for easier testing
./wp-cli.phar option update comment_moderation 0 --allow-root --path=$WP_DIR
./wp-cli.phar option update comment_whitelist 0 --allow-root --path=$WP_DIR


php-fpm7.4 -F &
trap "echo 'SIGTERM received'; exit 0" SIGTERM
wait $!