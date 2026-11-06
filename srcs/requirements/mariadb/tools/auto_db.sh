#!/bin/sh

if [! -d "/var/lib/mysql/wordpress"]; then
    mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null
    
    mysqld_safe --datadir='/var/lib/mysql' &
    until mysqladmin ping; do
        sleep 1
    done

    eval $(cat /run/secrets/db_root_password)
    eval $(cat /run/secrets/db_user_password)

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \'${MYSQL_DATABASE}\';"
    mysql -u root -e "CREATE USER IF NOT EXISTS \'${MYSQL_USER}\'@\'%\' IDENTIFIED BY \'${MYSQL_PASSWORD}\';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \'${MYSQL_USER}\'@\'%\';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown 

fi

exec mysqld_safe --datadir='/var/lib/mysql'

