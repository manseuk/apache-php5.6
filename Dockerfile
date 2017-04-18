FROM php:5.6-apache

MAINTAINER rodwin lising <rodwinlising@gmail.com>

# install the PHP extensions we need
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        git \
        libtidy-dev \
        nano \
    && docker-php-ext-install -j$(nproc) iconv mcrypt zip pdo_mysql tidy bcmath json \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

#install nodejs
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash

RUN apt-get install nodejs

# Install Composer
RUN curl -s http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && echo "alias composer='/usr/local/bin/composer.phar'" >> ~/.bashrc

# Source the bash
RUN . ~/.bashrc

RUN a2enmod rewrite

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/usr/local/etc/php", "/etc/apache2/sites-available", "/var/log/apache2", "/var/www/html"]

WORKDIR /var/www/html