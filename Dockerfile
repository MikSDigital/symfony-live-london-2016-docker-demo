FROM php:7.0-apache

MAINTAINER André Rømcke "ar@ez.no"

ENV COMPOSER_HOME=/root/.composer \
    SYMFONY_ENV=prod

# Copy project files into work dir
COPY . /var/www/html

# Get Composer dependancies, create Composer directory (cache and auth files) & Get Composer
RUN apt-get update -q -y \
    && apt-get install -q -y --force-yes --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $COMPOSER_HOME \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install -o -n --no-progress --prefer-dist \
    && echo "Clear cache and logs so container starts with clean slate" \
    && rm -Rf var/logs/* var/cache/*/* \
    && echo "Set permissions for www-data, add data folder if you have" \
    && chown -R www-data:www-data var/cache var/logs var/sessions


EXPOSE 80
CMD ["apache2-foreground"]
