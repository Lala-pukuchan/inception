# inception

# local
## local dns server
- [how to set up dns](https://blog.turai.work/entry/20190206/1549452268)

# vm
## ssh
```
ssh -p 22 debian@127.0.0.1
```
- using Remote - SSH extension

## install git
```
sudo apt update
sudo apt install git
git --version
git clone https://github.com/Lala-pukuchan/inception.git
```

## install docker
```
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
systemctl start docker
sudo apt install docker-compose
export DOCKER_HOST=localhost
```

## using docker without sudo
```
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo systemctl restart docker
exit
```

# install make
```
sudo apt-get update
sudo apt-get -y install make
```

## docker image
[sample Dockerfile for nginx](https://github.com/nginxinc/docker-nginx/blob/1a8d87b69760693a8e33cd8a9e0c2e5f0e8b0e3c/stable/alpine-slim/Dockerfile)
[nginx daemon off](https://tottoto-toto.hatenablog.com/)

## docker-compose
[how to write docker-compose.yml](https://docs.docker.com/compose/compose-file/build/)
[how to install nginx in Debian](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-debian-11)

## what is TLS?
- improved from SSL
[what is ssl certification](https://www.rworks.jp/system/system-column/sys-entry/21283/)
[how to create self-signed ssl certification](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-debian-10)
```
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./nginx/conf/ssl/private_key.pem -out ./nginx/conf/ssl/certificate.pem
Common Name (e.g. server FQDN or YOUR name) []:rukobaya.42.fr
RUN echo "Creating self-signed certificate for domain rukobaya.42.fr" && \
    openssl \
    req -x509 \
    -nodes \
    -subj "/CN=rukobaya.42.fr" \
    -days 365 \
    -newkey rsa:2048 -keyout /etc/nginx/ssl/private_key.pem \
    -out /etc/nginx/ssl/certificate.pem
```

## how to connect to rukobaya.42.fr from local server
```
sudo vi /etc/hosts
127.0.0.1	localhost rukobaya.42.fr
```

## PHP fpm
[what is php fpm](https://hackers-high.com/linux/php-fpm-config/)
[php fpm official image](https://github.com/docker-library/php/blob/21967e6cd5f1240093d4f0b03d579397571cab9c/8.0/alpine3.16/fpm/Dockerfile)
[what should be installed for php extension](https://qiita.com/dalchan/items/20e758fe8646e7c58df8)
[ref](https://53ningen.com/docker-wordpress)
```
FROM alpine:3.16
PHP_VERSION 8.0.28
```
```
FROM alpine:3.16

RUN set -x && \
	apk update && \
	apk add php8 php8-fpm php8-ftp php8-mbstring php8-mysqlnd
```

## word press
[word press official image](https://github.com/docker-library/wordpress/blob/6fa05d9ba94e7cb48a53ff90878cc6fc777f7986/latest/php8.0/fpm-alpine/Dockerfile)
- To check admin console, "wp-admin/" after url.

### Dockerfile for 
- [Dockerfile based on alphine](https://github.com/yobasystems/alpine-php-wordpress/blob/master/alpine-php-wordpress-aarch64/Dockerfile)

## docker network
[how to create bridge network](https://knowledge.sakura.ad.jp/26522/)
```
version: "3"
services:
  web:
    image: alpine
    command: ping 127.0.0.1
    networks:
      - frontend
  middle:
    image: alpine
    command: ping 127.0.0.1
    networks:
      - frontend
      - backend
  db:
    image: alpine
    command: ping 127.0.0.1
    networks:
      - backend
networks:
  frontend:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 192.168.10.0/24
  backend:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 192.168.20.0/24
```

## mariadb
### connect to mariadb
#### connect to mariadb from mariadb container
```
docker exec -it <mariadb container id> /bin/bash
apt-get update
apt-get install mysql-client -y
mysql -u ruru -p
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| wordpress_db       |
+--------------------+
```
#### connect to mariadb from wordpress container
```
docker exec -it <wordpress container id> /bin/bash
apk update && apk add --no-cache mysql-client
mysql -h mysql -u ruru -p

```

### Dockerfile for mariadb
- [Dockerfile based on alphine](https://github.com/yobasystems/alpine-mariadb/blob/master/alpine-mariadb-aarch64/files/run.sh)

