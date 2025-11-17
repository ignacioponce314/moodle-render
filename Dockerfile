FROM php:8.1-apache

RUN a2enmod rewrite

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git \
    libicu-dev \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip soap intl pgsql pdo_pgsql

WORKDIR /var/www/html
RUN rm -rf /var/www/html/*
RUN git clone -b MOODLE_400_STABLE https://github.com/moodle/moodle.git .
RUN chown -R www-data:www-data /var/www/html

RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www/moodledata \
    && chmod -R 777 /var/www/moodledata

RUN echo "display_errors=On" >> /usr/local/etc/php/conf.d/moodle.ini

EXPOSE 80
CMD ["apache2-foreground"]




