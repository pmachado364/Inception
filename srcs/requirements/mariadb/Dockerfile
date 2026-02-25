#set base image to Debian Bookworm
FROM debian:bookworm

#execute command to install mariadb-server package in the container
RUN apt-get update -q && \
    apt-get install -y mariadb-server gosu && \
    rm -rf /var/lib/apt/lists/*

#execute command to create directory for mysql and change ownership to mysql user
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

#copy entrypoint script and configuration file to the container and set permissions
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /usr/local/bin/entrypoint.sh

#expose port 3306 for mysql
EXPOSE 3306

#use entrypoint script to initialize and start mariadb server
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#execute command to start mariadb server
CMD ["mariadbd"]