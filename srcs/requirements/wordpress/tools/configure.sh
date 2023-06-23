#!/bin/sh

if ! wp core is-installed; then

	echo "[i] wp core not found, downloading...."
	wp core download --allow-root

    if [ ! -f "/var/www/html/index.html" ]; then
        echo "[i] creating conf...."
        wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    else
        echo "[i] wp conf already present, skipping creation"
    fi

    echo "[i] installing wordpress...."
    echo "[i] create admin user: $WORDPRESS_ADMIN, admin pass: $WORDPRESS_ADMIN_PASSWORD, admin email: $WORDPRESS_ADMIN_EMAIL"
    wp core install --url=$SERVER_NAME --title=Inception --admin_user=$WORDPRESS_ADMIN --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --allow-root
    
    echo "[i] create author user: $WORDPRESS_USER, user pass: $WORDPRESS_USER_PASSWORD, user email: $WORDPRESS_USER_EMAIL"
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASSWORD --allow-root

    echo "[i] installing wordpress theme...."
    wp theme install twentytwentyone --activate --allow-root

else
	echo "[i] wp core already present, skipping creation"
fi

echo "starting wordpress ...."
/usr/sbin/php-fpm7 -F -R
