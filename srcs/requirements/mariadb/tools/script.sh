mysqld &
sleep 5
mysql -e "CREATE DATABASE IF NOT EXISTS \ '${SQL_DATABASE}\';"
#mysqld -e "CREATE USE IF NOT EXISTS \'${SQL_USER}\'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
#mysqld -e "GRANT ALL PRIVILEGES ON \'${SQL_DATABASE}\'.* TO \'@'%'IDENTIFIED BY '${SQL_PASSWORD}';"
#rc-service mariadb start 
# which is  alpine equivalent to: systemctl start mariadb
