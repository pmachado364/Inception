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

CMD ["php-fpm", "-F"]