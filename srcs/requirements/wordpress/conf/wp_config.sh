sleep 10
wp config create	--allow-root \
                    --dbname=$SQL_DATABASE \
                    --dbuser=$SQL_USER \
                    --dbpass=$SQL_PWD \
                    --dbhost=mariadb:3306 --path='/var/www/wordpress'
wp core install
wp user create
/usr/sbin/php-fpm7.3 -F