#set base image to Debian Bookworm
FROM debian:bookworm

#install necessary packages for PHP-FPM
RUN apt-get update -q && \
    apt-get install -y --no-install-recommends \
        php-fpm \
        php-mysql \
        php-gd \
        php-curl \
        php-bcmath \
        php-zip \
        php-intl \
        php-xml \
        php-mbstring \
        mariadb-client \
        wget \
        tar \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

#install WP-CLI and install it in /usr/local/bin/wp for easy access (this makes the wp command globally available in the container)
#note : WP-CLI is a command-line tool for managing WordPress installations
#this allows us not having to install WordPress manually.
#download -> Make Executable -> Move to Global Path
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

#copy WordPress initialization script (runs at container startup)
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

#change permissions for the wordpress.sh script to make it executable
RUN chmod +x /usr/local/bin/wordpress.sh

#fix logging (So we can see errors)
RUN sed -i 's|error_log = .*|error_log = /dev/stderr|' /etc/php/*/fpm/php-fpm.conf

#configure PHP-FPM to listen on port 9000 and accept connections from any IP address.
#This allows NGINX to connect to PHP-FPM using the container's IP address and port 9000.
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

#we create the PID directory for PHP and the site directory for WordPress
#we give ownership of the WordPress directory to www-data (the user PHP runs as)
RUN mkdir -p /var/www/html && \
    mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html

#set working directory for WordPress files
WORKDIR /var/www/html

#expose port 9000 for PHP-FPM to listen for incoming requests
EXPOSE 9000

#use entrypoint script to initialize WordPress and start PHP-FPM server
ENTRYPOINT ["/usr/local/bin/wordpress.sh"]