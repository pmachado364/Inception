#set base image to Debian Bookworm
FROM debian:bookworm

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

#configure PHP-FPM to listen on port 9000 and accept connections from any IP address
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

#install WP-CLI and install it in /usr/local/bin/wp for easy access
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

#create WordPress document root and PHP-FPM runtime directory, set ownership for php-fpm (www-data)
RUN mkdir -p /run/php && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

#copy WordPress initialization script (runs at container startup)
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

#change permissions for the wordpress.sh script to make it executable
RUN chmod +x /usr/local/bin/wordpress.sh

#set working directory for WordPress files
WORKDIR /var/www/html

#expose port 9000 for PHP-FPM to listen for incoming requests
EXPOSE 9000

#use entrypoint script to initialize WordPress and start PHP-FPM server
ENTRYPOINT ["/usr/local/bin/wordpress.sh"]