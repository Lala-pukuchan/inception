# inception

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
[sample Dockerfile for nginx](https://github.com/nginxinc/docker-nginx/blob/73a5acae6945b75b433cafd0c9318e4378e72cbb/mainline/debian/Dockerfile)
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
```

## how to connect to rukobaya.42.fr from local server
```
sudo vi /etc/hosts

```