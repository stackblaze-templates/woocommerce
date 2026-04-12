FROM wordpress:php8.3-apache

# Install WooCommerce via WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY wp-content/plugins/ /var/www/html/wp-content/plugins/
EXPOSE 80
