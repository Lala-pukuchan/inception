# base os
FROM alpine:3.13

# install
RUN echo "Install package for nginx" \
    && apk update \
    && apk add --no-cache nginx openssl

# create dir
RUN echo "Create dir" \
    && mkdir -p /run/nginx \
    && mkdir -p /etc/nginx/ssl

# ssl
RUN echo "Create self-signed certificate for domain rukobaya.42.fr" \
    && openssl \
        req -x509 \
        -nodes \
        -subj "/CN=rukobaya.42.fr" \
        -days 365 \
        -newkey rsa:2048 -keyout /etc/nginx/ssl/private.key \
        -out /etc/nginx/ssl/cert.pem

# port
EXPOSE 443

# cmd
CMD ["nginx", "-g", "daemon off;"]
