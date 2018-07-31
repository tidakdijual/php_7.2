FROM php:7.2-apache

RUN apt-get update && apt-get install -y \
        unzip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libaio1 \
    && docker-php-ext-install -j$(nproc) iconv mcrypt gettext mbstring mysqli pgsql pdo_mysql pdo_pgsql \
    && docker-php-ext-install -j$(nproc) curl ftp hash json session tokenizer xml xmlreader xmlrpc xmlwriter zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

COPY docker-php.conf /etc/apache2/conf-enabled/docker-php.conf

RUN printf "log_errors = On \nerror_log = /dev/stderr\n" > /usr/local/etc/php/conf.d/php-logs.ini

RUN a2enmod rewrite

RUN apt-get install nano -y

RUN echo "<?php echo phpinfo(); ?>" > /var/www/html/phpinfo.php

EXPOSE 80
