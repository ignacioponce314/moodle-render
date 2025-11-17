FROM php:8.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git \
    libicu-dev

# Configurar GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Extensiones PHP
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install zip
RUN docker-php-ext-install soap
RUN docker-php-ext-install intl   # ← ahora sí instala!
RUN docker-php-ext-install opcache

# Extensiones PostgreSQL
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql

# Habilitar mod_rewrite
RUN a2enmod rewrite
RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Copiar Moodle
COPY . /var/www/html/

# moodledata
RUN mkdir -p /var/www/moodledata \
    && chmod -R 0777 /var/www/moodledata \
    && chown -R www-data:www-data /var/www/moodledata /var/www/html

EXPOSE 80



