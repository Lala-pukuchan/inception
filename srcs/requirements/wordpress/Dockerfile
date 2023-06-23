# base os
FROM alpine:3.13

# install
RUN apk add --no-cache bash curl less vim tzdata zip mariadb-client \
    php7-fpm php7-json php7-zlib php7-xml php7-xmlwriter php7-simplexml php7-pdo php7-phar php7-openssl \
    php7-pdo_mysql php7-mysqli php7-session \
    php7-gd php7-iconv php7-gmp php7-zip \
    php7-curl php7-opcache php7-ctype php7-apcu \
    php7-intl php7-bcmath php7-dom php7-mbstring php7-xmlreader mysql-client curl && apk add -u musl && \
    rm -rf /var/cache/apk/*

# add user for nginx process
RUN	adduser -S nginx &&	addgroup -S nginx

# conf for global setting of process mgt (TO DO: check conf)
COPY /conf/php-fpm.conf /etc/php7/php-fpm.conf

# conf for php-fpm pool
COPY /conf/www.conf /etc/php7/php-fpm.d/www.conf

# install wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp

# workdir
WORKDIR /var/www/html/wordpress

# execute shell
COPY tools/configure.sh /tmp/configure.sh
ENTRYPOINT [ "sh", "/tmp/configure.sh" ]
