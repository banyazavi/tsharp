ARG version_torrssen2=latest
FROM tarpha/torrssen2:${version_torrssen2}

ARG build_date=unknown
ARG version_torrssen2=latest
ENV BUILD_DATE ${build_date}
ENV VERSION_TORRSSEN2 ${version_torrssen2}
ENV PUID 0
ENV PGID 100

# Install packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    openssl \
    transmission-daemon \
    nginx \
    php7.4 \
    php7.4-fpm \
    php7.4-curl

# Transmission
RUN mkdir -p /config

# Nginx
RUN rm /var/www/html/index.nginx-debian.html && \
    mkdir -p /var/www/html/torr && \
    chown -R www-data:www-data /var/www/html

# Copy files
COPY ./defaults/settings.json /defaults/settings.json
COPY ./defaults/default /etc/nginx/sites-available/default
COPY ./defaults/run.sh /run.sh

# Initial script
RUN chmod 0555 /run.sh

# Ports and Volumes
EXPOSE 8080
VOLUME /root/data /download

# Run
ENTRYPOINT /run.sh
