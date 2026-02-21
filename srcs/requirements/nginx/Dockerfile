#set base image to Debian Bookworm
FROM debian:bookworm

#install necessary packages for Nginx
RUN apt-get update -q && \
	apt-get install -y nginx && \
	apt-get install -y openssl && \
	rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/sites-enabled/default
RUN rm -f /var/www/html/index.nginx-debian.html

#create SSL directories
RUN mkdir -p /etc/ssl/private

#generate self-signed certificate
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=PT/ST=Porto/L=Porto/O=42/OU=Inception/CN=localhost"

#copy the Nginx configuration file to the container
COPY conf/site.conf /etc/nginx/conf.d/default.conf

#expose port 443 for HTTPS traffic
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]