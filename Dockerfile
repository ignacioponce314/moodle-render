FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev unzip libxml2-dev libzip-dev git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli opcache zip soap intl

RUN a2enmod rewrite

RUN git clone -b MOODLE_401_STABLE https://github.com/moodle/moodle.git /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
