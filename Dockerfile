FROM ubuntu:18.04

# Install "software-properties-common" (for the "add-apt-repository")
RUN apt-get update && apt-get install -y \
    software-properties-common locales

RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

# Add the "PHP 7" ppa
RUN add-apt-repository -y \
    ppa:ondrej/php

# Install PHP-CLI 7, some PHP extentions and some useful Tools with APT
RUN apt-get update && apt-get install -y --force-yes \
        php7.4-cli \
        php7.4-common \
        php7.4-curl \
        php7.4-json \
        php7.4-xml \
        php7.4-mbstring \
        php7.4-mysql \
        php7.4-pgsql \
        php7.4-sqlite \
        php7.4-sqlite3 \
        php7.4-zip \
        php7.4-memcached \
        php7.4-gd \
        php7.4-fpm \
        php7.4-xdebug \
        php7.4-bcmath \
        php7.4-intl \
        php7.4-dev \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        sqlite3 \
        libsqlite3-dev \
        git \
        curl \
        vim \
        nano \
        net-tools \
        pkg-config \
        iputils-ping

# remove load xdebug extension (only load on phpunit command)
# RUN sed -i 's/^/;/g' /etc/php/7.2/cli/conf.d/20-xdebug.ini

# Load xdebug Zend extension with phpunit command
# RUN echo "alias phpunit='php -dzend_extension=xdebug.so /var/www/laravel/vendor/bin/phpunit'" >> ~/.bashrc

# Add bin folder of composer to PATH.
RUN echo "export PATH=${PATH}:/var/www/laravel/vendor/bin:/root/.composer/vendor/bin" >> ~/.bashrc

# Install mongodb extension
RUN pecl channel-update pecl.php.net && pecl install mongodb
RUN echo "extension=mongodb.so" >> /etc/php/7.2/cli/php.ini

# Install Nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g eslint babel-eslint eslint-plugin-react yarn

# Install Composer, PHPCS and Framgia Coding Standard,
# PHPMetrics, PHPDepend, PHPMessDetector, PHPCopyPasteDetector
RUN curl -s http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require 'squizlabs/php_codesniffer' \
        'phpmetrics/phpmetrics' \
        'pdepend/pdepend' \
        'phpmd/phpmd' \
        'sebastian/phpcpd' 

# Create symlink
RUN ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs \
    && ln -s /root/.composer/vendor/bin/pdepend /usr/bin/pdepend \
    && ln -s /root/.composer/vendor/bin/phpmetrics /usr/bin/phpmetrics \
    && ln -s /root/.composer/vendor/bin/phpmd /usr/bin/phpmd \
    && ln -s /root/.composer/vendor/bin/phpcpd /usr/bin/phpcpd

# install docker

RUN sudo apt update
RUN  apt install apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt update
RUN apt-cache policy docker-ce
RUN  apt install docker-ce
RUN  systemctl status docker

#install docker-composer
RUN apt install docker-compose
# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/laravel
