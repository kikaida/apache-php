FROM php:5.6-apache
MAINTAINER Pepsi "maddog@gmail.com"
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
		wget \
		nano \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mysqli mbstring exif zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
	&& echo "ServerName localhost" >> /etc/apache2/apache2.conf \
	&& a2dissite *default \
	&& mkdir /var/www/html/lychee \
	&& mkdir -p /var/www/html/lychee/public_html \
	&& mkdir -p /var/www/html/lychee/log \
	&& mkdir -p /var/www/html/lychee/backups
ADD lychee.conf /etc/apache2/sites-available/
ADD phpinfo.php /var/www/html/lychee/public_html/
ADD php.ini /usr/local/etc/php/
RUN a2ensite lychee.conf \
    && a2enmod rewrite
COPY lychee/ /var/www/html/lychee/public_html/
