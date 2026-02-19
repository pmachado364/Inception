#!/bin/bash

# This script is the entry point for the WordPress container.

#exit immediately if any command exits with a non-zero status.
set -e

#verify is the database is ready to accept connections
until mariadb-admin ping --silent; do
	sleep 1
done

#check if the WordPress configuration file exists, if not, create it
if [ ! -f "/var/www/html/wp-config.php" ]; then
	echo "WordPress configuration initiating ..."
	exec php-fpm -F
	else
	echo "WordPress configuration already exists, starting the server ..."
	exec php-fpm -F
fi
