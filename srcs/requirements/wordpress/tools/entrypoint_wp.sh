#!/bin/bash

set -e

echo "Waiting on MariaDB to be ready."

#wait until the database is ready
until mysqladmin ping \
	-h mariadb \
	-u "$DB_USER" \
	-p"$DB_PASSWORD" \
	--silent; do
	echo "MariaDB is not ready yet. Retrying in 5 seconds."
	sleep 5
done

echo "MariaDB is ready."

#if WordPress core files don't exist → download
if [ ! -f /var/www/html/wp-load.php ]; then
    wp core download --allow-root
fi

#if config does not exist → create config
if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="mariadb" \
        --allow-root
fi

#if not installed in DB → install
if ! wp core is-installed --allow-root; then
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception WordPress" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
fi

chown -R www-data:www-data /var/www/html

echo "WordPress is ready."

exec php-fpm8.2 -F