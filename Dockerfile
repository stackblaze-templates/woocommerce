FROM wordpress:php8.3-apache

# Install WooCommerce via WP-CLI (verify integrity before installing)
RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o wp-cli.phar && \
    curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar.sha512 -o wp-cli.phar.sha512 && \
    sha512sum --check wp-cli.phar.sha512 && \
    rm wp-cli.phar.sha512 && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY wp-content/plugins/ /var/www/html/wp-content/plugins/
EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -fsSL http://localhost/wp-login.php || exit 1
