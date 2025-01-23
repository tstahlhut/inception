#!/bin/sh

set -e

# Check if all required environment variables are set
: "${MYSQL_DATABASE:?Environment variable MYSQL_DATABASE is required}"
: "${MYSQL_USER_FILE:?Environment variable MYSQL_USER is required}"
: "${MYSQL_PASSWORD_FILE:?Environment variable MYSQL_PASSWORD is required}"
: "${MYSQL_ROOT_PASSWORD_FILE:?Environment variable MYSQL_ROOT_PASSWORD is required}"

# Replace placeholders in SQL script
SQL_FILE="/etc/mysql/init.sql"
if [ -f "$SQL_FILE" ]; then
	sed -i "s/\${MYSQL_DATABASE}/${MYSQL_DATABASE}/g" "$SQL_FILE"
	sed -i "s/\${MYSQL_USER_FILE}/$(cat "${MYSQL_USER_FILE}")/g" "$SQL_FILE"
	sed -i "s/\${MYSQL_PASSWORD_FILE}/$(cat "${MYSQL_PASSWORD_FILE}")/g" "$SQL_FILE"
	sed -i "s/\${MYSQL_ROOT_PASSWORD_FILE}/$(cat "${MYSQL_ROOT_PASSWORD_FILE}")/g" "$SQL_FILE"
else
	echo "SQL script not found"
	exit 1
fi

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# The datadir located at /var/lib/mysql must be owned by the mysql user and group.
chown -R mysql:mysql /var/lib/mysql

# If MariaDB data directory empty, initialize it
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB database ... "
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	echo "MariaDB database initialized"
fi

# Run SQL init script
echo "Running SQL script ... "
usr/bin/mysqld --user=mysql --bootstrap < ${SQL_FILE}
echo "MariaDB configuration done"

# Start MariaDB service
exec /usr/bin/mysqld --user=mysql --console