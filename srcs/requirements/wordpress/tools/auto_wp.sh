#!/bin/sh

until mysqladmin ping -h"mariadb" --silent;do
    sleep 2
done

if [! -f /var/www/html/wp-config.php ]; then
    eval $(cat /run/secrets/db_password)

    mkdir -p /var/www/html
    cd /var/www/html

    wp core download --allow-root


    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root
    
    wp core install \
        --url="https://${DOMAIN_NAME}" \ 
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    wp user create  "${WP_USER}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PASSWORD}" --role=author --allow-root

fi

mkdir -p /run/php
exec php-fpm7.3 -F


