# Set base image to Debian Bookworm
FROM debian:bookworm

RUN apt-get update -q && \
	apt-get install -q -y \
		php-fpm \
		php-mysql \
		wget \
		tar && \
		rm -rf /var/lib/apt/lists/*

# Create WordPress document root and set ownership for php-fpm (www-data)
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Copy WordPress initialization script (runs at container startup)
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

# Change permissions for the wordpress.sh script to make it executable
RUN chmod +x /usr/local/bin/wordpress.sh

# Set working directory for WordPress files
WORKDIR /var/www/html

EXPOSE 9000