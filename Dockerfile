FROM php:8.2-fpm

COPY . /var/www

RUN apt-get update
RUN apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd zip
RUN apt-get update && apt-get install -y nginx supervisor

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
RUN composer install --no-dev --optimize-autoloader

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
