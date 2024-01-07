FROM php:8.3.0-fpm

ENV TZ=Europe/Moscow

RUN apt-get update \
   && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
   && echo $TZ > /etc/timezone \
   && apt-get install -y wget git unzip bzip2 nano less tar tzdata libmcrypt-dev libonig-dev libxml2-dev libxslt-dev libpq-dev libzip-dev libbz2-dev libfontconfig1 libxrender1 libxext6 zlib1g-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev libwebp-dev libmemcached-dev \
   && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
   && docker-php-ext-install bcmath bz2 gd pdo_mysql pdo_pgsql soap xml xsl exif opcache sockets zip mysqli \
   && pecl install memcached-3.1.5 \
   && pecl install xdebug-3.3.1 \
   && pecl install mcrypt-1.0.7 \
   && docker-php-ext-enable memcached \
   && docker-php-ext-enable xdebug \
   && docker-php-ext-enable mcrypt \
   && apt-get install -y locales \
   && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
   && sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen \
   && locale-gen \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* \
   && mkdir -p --mode=777 /tmp/xdebug \
   && wget https://getcomposer.org/installer -O - -q \
    | php -- --install-dir=/bin --filename=composer --quiet

ADD ./php.ini /usr/local/etc/php/php.ini
ADD ./xdebug-debug.ini /usr/local/etc/php/conf.d/xdebug.ini

ENV LANG en_US.UTF-8
ENV LANGUAGE en_EN:en
ENV LC_LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /var/www
