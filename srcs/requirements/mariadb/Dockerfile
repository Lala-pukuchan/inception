# base os
FROM alpine:3.13

# install
RUN echo "Install package for mariadb" \
    && apk update \
    && apk add --no-cache mariadb mariadb-client

# port
#EXPOSE 3306

# entrypoint
ENTRYPOINT ["sh", "/tools/configure.sh"]
