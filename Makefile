up:
	docker-compose -f srcs/docker-compose.yml up -d
down:
	docker-compose -f srcs/docker-compose.yml down
loginNginx:
	docker exec -it nginx /bin/bash
loginWordpress:
	docker exec -it wordpress /bin/bash
loginDb:
	docker exec -it db /bin/bash
.PHONY: up stop down loginNginx loginWordpress loginDb
