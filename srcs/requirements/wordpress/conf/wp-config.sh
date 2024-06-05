# !/bin/bash

# Only if wp-config.php doesnt already exist
if [ ! -f "${WP_PATH}/wp-config.php" ]; then

  # Wordpress install
  wp core download --path=$WP_PATH --allow-root
  echo "core downloaded" >&2
  sleep 10
  # Wordpress config initialization
  wp config create --allow-root \
    --dbname=$SQL_DATABASE \
    --dbuser=$SQL_USER \
    --dbpass=$SQL_PWD \
    --dbhost=mariadb:3306 \
    --path=$WP_PATH
  echo "wp-config.php created"
  echo "Setting up admin" >&2
  # More wordpress config, admin user
  wp core install --allow-root \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PWD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --path=$WP_PATH
  echo "Setting up user" >&2
  # user creation (mfinettos)
  wp user create $WP_USER $WP_USER_EMAIL \
    --user_pass=$WP_USER_PWD \
    --allow-root \
    --path=$WP_PATH

  echo "define('WP_DEBUG', true);" >> ${WP_PATH}/wp-config.php
  echo "define('WP_DEBUG_LOG', true);" >> ${WP_PATH}/wp-config.php
  echo "define('WP_DEBUG_DISPLAY', false);" >> ${WP_PATH}/wp-config.php
fi

chown -R www-data:www-data /var/www/wordpress/


# Run PHP
mkdir -p /run/php
echo "Inception launched" >&2
php-fpm7.4 -F
