# !/bin/bash

# Execution du script si wp-config n'existe pas
if [ ! -f "${WP_PATH}/wp-config.php" ]; then

  # Installation de Wordpress
  wp core download --path=$WP_PATH --allow-root
  echo "core downloaded" >&2
  sleep 10
  # Configuration de Wordpress avec des variables d'environnement
  wp config create --allow-root \
    --dbname=$SQL_DATABASE \
    --dbuser=$SQL_USER \
    --dbpass=$SQL_PWD \
    --dbhost=mariadb:3306 \
    --path=$WP_PATH
  echo "wp-config.php created"
  # # Configure WordPress to use SMTP for sending emails
  # wp config set --allow-root \
  #   --type=constant \
  #   --raw \
  #   WP_MAIL_HOST smtp.example.com
  # wp config set --allow-root \
  #   --type=constant \
  #   --raw \
  #   WP_MAIL_PORT 587
  # wp config set --allow-root \
  #   --type=constant \
  #   --raw \
  #   WP_MAIL_USERNAME your_smtp_username
  # wp config set --allow-root \
  #   --type=constant \
  #   --raw \
  #   WP_MAIL_PASSWORD your_smtp_password
  # wp config set --allow-root \
  #   --type=constant \
  #   --raw \
  #   WP_MAIL_SECURE tls
  echo "Setting up admin" >&2
  wp core install --allow-root \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PWD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --path=$WP_PATH
  echo "Setting up user" >&2
  wp user create $WP_USER $WP_USER_EMAIL \
    --user_pass=$WP_USER_PWD \
    --allow-root \
    --path=$WP_PATH

fi

chown -R www-data:www-data /var/www/wordpress/

# Run PHP
mkdir -p /run/php
php-fpm7.4 -F

echo "Inception launched" >&2