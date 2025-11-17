FROM php:8.2-apache

# Actualizar e instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git

# Configurar e instalar GD (separado para evitar errores)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Instalar extensiones PHP una por una (esto evita fallos ocultos)
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install zip
RUN docker-php-ext-install soap
RUN docker-php-ext-install intl
RUN docker-php-ext-install opcache

# EXTENSIONES DE POSTGRESQL (lo que Moodle NECESITA)
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql

# Activar mod_rewrite para Moodle
RUN a2enmod rewrite
RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Copiar Moodle al servidor
COPY . /var/www/html/

# Crear carpeta moodledata
RUN mkdir -p /var/www/moodledata \
    && chmod -R 0777 /var/www/moodledata \
    && chown -R www-data:www-data /var/www/moodledata /var/www/html

EXPOSE 80


