#!/bin/sh
set -e

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    until mysqladmin ping --silent; do
        sleep 1
    done

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

# exec: mysqld PID 1 olur, docker stop'un SIGTERM'unu dogrudan alir (graceful shutdown).
# mysqld_safe bir shell wrapper oldugu icin sinyali iletmiyordu (Exited 137).
exec mysqld --user=mysql --datadir=/var/lib/mysql
