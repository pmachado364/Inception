#set base image to Debian Bookworm
FROM debian:bookworm

#execute command to install mariadb-server package in the container
RUN apt-get update -q && \
	apt-get install -q -y mariadb-server

#execute command to create directory for mysql and change ownership to mysql user
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

#copy entrypoint script to the container and set permissions
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

#expose port 3306 for mysql
EXPOSE 3306

#use entrypoint script to initialize and start mariadb server
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#execute command to start mariadb server
CMD ["mariadbd"]