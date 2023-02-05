# Install php from docker (adjust the php version with your apps) 
FROM php:8.2.1-fpm

# Update & upgrade apt
RUN apt-get update && apt-get upgrade -y
RUN apt install -y apt-utils

# Install dependencies
RUN apt-get install -qq -y \
  nano \
  curl \
  libcurl3-dev \
  openssl \
  git \
  libzip-dev \
  zlib1g-dev \
  zip unzip \
  nginx

# Install extensions
# https://gist.github.com/hoandang/88bfb1e30805df6d1539640fc1719d12 <- reference

RUN apt-get update && apt-get install -y \ 
libicu-dev \
libxml2-dev \
libpq-dev \
libbz2-dev \
libjpeg-dev \
libpng-dev \
libfreetype6-dev \
libjpeg62-turbo-dev

RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/

RUN docker-php-ext-install \
bcmath \
bz2 \
calendar \
exif \
gd \
gettext \
intl \
opcache \
pgsql \
pdo \
pdo_pgsql \
pdo_mysql \
pcntl \
zip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy config file php <- comment this "COPY" function if you use volume on dokcer compose (.yml file)
ENV PHP_DIR=./config/php
COPY ${PHP_DIR}/local.ini /usr/local/etc/php/conf.d/local.ini
COPY ${PHP_DIR}/www.conf /usr/local/etc/php-fpm.d/www.conf

# Copy config file nginx <- comment this "COPY" function if you use volume on dokcer compose (.yml file)
ENV NGINX_DIR=./config/nginx
COPY ${NGINX_DIR}/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY ${NGINX_DIR}/nginx.conf /etc/nginx/nginx.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \ 
  --install-dir=/usr/local/bin --filename=composer && chmod +x /usr/local/bin/composer 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install Node js
ENV NODE_VERSION=18.13.0
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.1/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Init workdir & copy file to workdir <- comment this "COPY" function if you use volume on dokcer compose (.yml file)
ENV APPS_DIR=./apps
ENV WORK_DIR=/var/www/html
WORKDIR ${WORK_DIR}
# COPY ${APPS_DIR} ${WORK_DIR}

# Change owner to www-data & permission storage to 755
RUN chown -R www-data:www-data ${WORK_DIR}
# RUN chmod -R 755 ${WORK_DIR}/storage

# Command to run service nginx & php-fpm when the container start
CMD ["/bin/bash", "-c", "service nginx start && php-fpm"]