# Atualizar o Dockerfile com suporte à extensão ZIP
dockerfile_with_zip = """FROM php:8.2-apache

RUN apt-get update && apt-get install -y \\
    unzip \\
    libpng-dev \\
    libonig-dev \\
    libxml2-dev \\
    libcurl4-openssl-dev \\
    libicu-dev \\
    libzip-dev \\
    zip \\
    curl \\
    git \\
    && docker-php-ext-install zip \\
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd intl curl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY app.zip /var/www/html/
RUN unzip app.zip && rm app.zip

RUN a2enmod rewrite

RUN echo "DirectoryIndex login.php index.php" > /etc/apache2/conf-available/custom-directoryindex.conf \\
    && a2enconf custom-directoryindex

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
"""

# Salvar novo Dockerfile
with open("/mnt/data/php_nginx_https/Dockerfile", "w") as f:
    f.write(dockerfile_with_zip)

# Criar novo zip final com a correção da extensão ZIP
final_zip_with_zip_path = "/mnt/data/php_nginx_https_with_zip_fix.zip"
with zipfile.ZipFile(final_zip_with_zip_path, 'w') as zipf:
    for foldername, subfolders, filenames in os.walk("/mnt/data/php_nginx_https"):
        for filename in filenames:
            filepath = os.path.join(foldername, filename)
            arcname = os.path.relpath(filepath, "/mnt/data/php_nginx_https")
            zipf.write(filepath, arcname)

final_zip_with_zip_path
