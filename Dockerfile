FROM php:8.1-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git \
    zlib1g-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl mysqli zip soap opcache \
    && rm -rf /var/lib/apt/lists/*

# Activar mod_rewrite de Apache
RUN a2enmod rewrite

# Descargar Moodle (estable)
RUN git clone -b MOODLE_401_STABLE https://github.com/moodle/moodle.git /var/www/html

# Establecer permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
