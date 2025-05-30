FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    zip \
    curl \
    git \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd intl curl

# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY app.zip /var/www/html/
RUN unzip app.zip && rm app.zip

RUN a2enmod rewrite

RUN echo "DirectoryIndex login.php index.php" > /etc/apache2/conf-available/custom-directoryindex.conf \
    && a2enconf custom-directoryindex

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
