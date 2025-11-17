FROM php:8.2-apache

# Instalar dependencias de Moodle + PostgreSQL
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli opcache zip soap intl pgsql pdo_pgsql

# Habilitar mod_rewrite para Apache (Moodle lo requiere)
RUN a2enmod rewrite

# Configuración de Apache para permitir .htaccess
RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Copiar contenido del repositorio (tu Moodle) al servidor web
COPY . /var/www/html/

# Crear carpeta moodledata si no existe
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www/moodledata \
    && chmod -R 0777 /var/www/moodledata

# Ajustar permisos del código Moodle
RUN chown -R www-data:www-data /var/www/html

# Exponer puerto 80
EXPOSE 80

