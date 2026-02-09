#!/bin/bash

# This script is the entry point for the MariaDB container.

#exit immediately if any command exits with a non-zero status.
set -e

#set a marker file to indicate that the database has been initialized
INIT_FILE="/var/lib/mysql/.initialized"

#check if the marker file exists, if not, initialize the database
if [ ! -f "$INIT_FILE" ]; then
	echo "mariadb initialization ..."
	gosu mysql mariadbd &
	#wait until mariadb is ready to accept connections
	until mariadb-admin ping --silent; do
		sleep 1
	done

	echo "mariadb initialized successfully. Initializing SQL..."

	#run the SQL initialization script to set up the database schema and initial data
	    mariadb << EOF
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
		FLUSH PRIVILEGES;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
EOF

	#Create the marker file to indicate that the database has been initialized
	touch "$INIT_FILE"
	mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown
	echo "mariadb initialization finished."
fi

#execute the command passed as arguments to the script
exec gosu mysql "$@"