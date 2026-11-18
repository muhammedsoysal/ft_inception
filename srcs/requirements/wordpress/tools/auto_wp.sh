#!/bin/sh
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)

WP_ADMIN_PASSWORD=$(grep '^WP_ADMIN_PASSWORD=' /run/secrets/credentials | cut -d '=' -f 2-)
WP_USER_PASSWORD=$(grep '^WP_USER_PASSWORD=' /run/secrets/credentials | cut -d '=' -f 2-)

until mariadb-admin ping -h mariadb --silent; do
    sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
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

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root

    chown -R www-data:www-data /var/www/html
fi

mkdir -p /run/php

exec php-fpm8.2 -F
