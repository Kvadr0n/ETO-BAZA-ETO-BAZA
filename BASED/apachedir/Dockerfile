FROM php:7.4.18-apache
RUN apt-get update
RUN apt-get -y install libaprutil1-dbd-mysql
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis
RUN docker-php-ext-install mysqli
RUN a2enmod dbd
RUN a2enmod authn_dbd
RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available
COPY php.ini /usr/local/etc/php
RUN cd ~ \
&&  curl -sS https://getcomposer.org/installer -o composer-setup.php \
&&  php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip \
	libpng-dev
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN cd /var/www \
&&  export COMPOSER_ALLOW_SUPERUSER=1 \
&&  composer require fakerphp/faker