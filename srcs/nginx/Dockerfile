FROM debian:bullseye-slim

RUN set -x \
	&& apt-get update \
	&& apt-get install nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
