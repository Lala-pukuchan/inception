FROM alpine:3.13

RUN apk update \
    && apk add --no-cache nginx \
    && mkdir -p /run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
