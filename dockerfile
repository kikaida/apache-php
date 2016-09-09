FROM php:5.6-apache
MAINTAINER Kikaida "shimabuku65@gmail.com"
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
		wget \
		nano \
		git \
		imagemagick \
		php5-imagick \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mysqli mbstring exif zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
	&& echo "ServerName localhost" >> /etc/apache2/apache2.conf \
	&& a2dissite *default \
	&& mkdir /var/www/html/lychee \
	&& mkdir -p /var/www/html/lychee/public_html \
	&& mkdir -p /var/www/html/lychee/log \
	&& mkdir -p /var/www/html/lychee/backups \
	&& git clone https://github.com/electerious/Lychee.git /var/www/html/lychee/public_html/ \
	&& chown -R www-data:www-data /var/www/html/lychee/public_html \
	&& chmod -R 770 /var/www/html/lychee/public_html \
	&& chmod -R 777 /var/www/html/lychee/public_html/uploads/ \
	&& chmod -R 777 /var/www/html/lychee/public_html/data
ADD lychee.conf /etc/apache2/sites-available/
ADD phpinfo.php /var/www/html/lychee/public_html/
ADD php.ini /usr/local/etc/php/
WORKDIR /
RUN a2ensite lychee.conf \
    && a2enmod rewrite \
	&& ln -s /var/www/html/lychee/public_html/uploads uploads \
	&& ln -s /var/www/html/lychee/public_html/data data
VOLUME /uploads
VOLUME /data
