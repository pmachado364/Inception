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

#if the wordpress config file doesn't exist, create it and download wordpress
if [ ! -f "/var/www/html/wp-config.php" ]; then
	echo "WordPress is not configured. Configuring now."

	#we need to download wordpress and create the config file before starting php-fpm, otherwise it will fail because of missing files
	wp core download --allow-root
	# create the wp-config.php file with the database credentials and the database host set to mariadb, which is the name of the service in docker-compose
	wp config create \
	--dbname="$DB_NAME" \
	--dbuser="$DB_USER" \
	--dbpass="$DB_PASSWORD" \
	--dbhost="mariadb" \
	--allow-root

	#if the database is empty, we need to install wordpress
	wp core install \
	--url="localhost" \
	--title="Inception WordPress" \
	--admin_user="$WP_ADMIN_USER" \
	--admin_password="$WP_ADMIN_PASSWORD" \
	--admin_email="$WP_ADMIN_EMAIL" \
	--allow-root
fi

chown -R www-data:www-data /var/www/html

echo "WordPress is ready."

exec php-fpm8.2 -F