FROM php:8.4-fpm

# Añadimos libpq-dev que es necesaria para PostgreSQL
RUN apt-get update && apt-get install -y \
    git unzip curl zip \
    libpng-dev libonig-dev libxml2-dev \
    libpq-dev

# Añadimos pdo_pgsql a la lista de extensiones
RUN docker-php-ext-install pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# Xdebug solo en desarrollo
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www