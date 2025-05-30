from php:8.2-apache

run apt-get update && apt-get install -y \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libzip-dev \
    zip \
    curl \
    git \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd intl curl

copy --from=composer:latest /usr/bin/composer /usr/bin/composer

workdir /var/www/html

copy app.zip /var/www/html/
run unzip app.zip && rm app.zip

run a2enmod rewrite

run echo "DirectoryIndex login.php index.php" > /etc/apache2/conf-available/custom-directoryindex.conf \
    && a2enconf custom-directoryindex

run chown -R www-data:www-data /var/www/html

expose 80

cmd ["apache2-foreground"]
