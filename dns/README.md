# Docker＆dnsmasqでローカルにオレオレDNSサーバーを構築

See http://thr3a.hatenablog.com/entry/20190206/1549452268

# ab 

```
docker-compose exec ab ab -c 4 -n 10000 http://192.168.1.xx:3000/
```