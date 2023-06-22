#!/bin/sh

# wait for mysql
#while ! mariadb -h$WORDPRESS_DB_HOST -u$WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD $WORDPRESS_DB_NAME &>/dev/null; do
#    sleep 3
#done

#if ! wp core is-installed; then
#    wp core download --allow-root
#    wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
#    #wp core install --url=localhost --title=Inception --admin_user=$WORDPRESS_ADMIN --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL
#    #wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
#fi

# indexがあるかが条件になっているので、変えたい
if [ ! -f "/var/www/html/index.html" ]; then

    # static website
    mv /tmp/index.html /var/www/html/index.html

    # adminer
    #wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql-en.php -O /var/www/html/adminer.php &> /dev/null
    #wget https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css -O /var/www/html/adminer.css &> /dev/null

    wp core download --allow-root
    wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    #wp core install --url=$DOMAIN_NAME/wordpress --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
    #wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
    #wp theme install inspiro --activate --allow-root

    # enable redis cache
    #sed -i "40i define( 'WP_REDIS_HOST', '$REDIS_HOST' );"      wp-config.php
    #sed -i "41i define( 'WP_REDIS_PORT', 6379 );"               wp-config.php
    ##sed -i "42i define( 'WP_REDIS_PASSWORD', '$REDIS_PWD' );"   wp-config.php
    #sed -i "42i define( 'WP_REDIS_TIMEOUT', 1 );"               wp-config.php
    #sed -i "43i define( 'WP_REDIS_READ_TIMEOUT', 1 );"          wp-config.php
    #sed -i "44i define( 'WP_REDIS_DATABASE', 0 );\n"            wp-config.php

    #wp plugin install redis-cache --activate --allow-root
    wp plugin update --all --allow-root

fi

#wp redis enable --allow-root

echo "Wordpress started on :9000"
/usr/sbin/php-fpm7 -F -R