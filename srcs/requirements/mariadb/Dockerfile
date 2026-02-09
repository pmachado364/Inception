#set base image to Debian Bookworm
FROM debian:bookworm

#execute command to install mariadb-server package in the container
RUN apt-get update -q && \
	apt-get install -q -y mariadb-server gosu

#execute command to create directory for mysql and change ownership to mysql user
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

#copy entrypoint script and configuration file to the container and set permissions
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /usr/local/bin/entrypoint.sh

#expose port 3306 for mysql
EXPOSE 3306

#use entrypoint script to initialize and start mariadb server
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#execute command to start mariadb server
CMD ["mariadbd"]