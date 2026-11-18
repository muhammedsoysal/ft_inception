#!/bin/sh
set -e

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mariadb

if [ ! -d "/var/lib/mariadb/${MYSQL_DATABASE}" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mariadb > /dev/null

    mariadbd --user=mysql --datadir=/var/lib/mariadb --skip-networking &
    TEMP_PID=$!
    until mariadb-admin ping --silent; do
        sleep 1
    done

    mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mariadb -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
    mariadb -u root -e "FLUSH PRIVILEGES;"
    mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

    mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "${TEMP_PID}"
fi

exec mariadbd --user=mysql --datadir=/var/lib/mariadb
