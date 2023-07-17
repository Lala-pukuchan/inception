all: up
up:
	docker compose -f srcs/docker-compose.yml up --build
up-d:
	docker compose -f srcs/docker-compose.yml up -d
down:
	docker compose -f srcs/docker-compose.yml down
pr-c:
	docker container prune
pr-v:
	docker volume prune
pr-i:
	docker image prune -a
pr-all:
	docker system prune --volumes

.PHONY: up up-d down pr-c pr-v pr-i pr-all
