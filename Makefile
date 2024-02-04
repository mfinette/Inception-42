include srcs/.env

DOCKER_COMPOSE := docker compose -f srcs/docker-compose.yml
_END			:=	\033[0m
_GREEN			:=	\033[32m

all:	$(WP_VOLUME_PATH) $(MARIADB_VOLUME_PATH)
		docker compose -f ./srcs/docker-compose.yml up --build

down:
		docker compose -f ./srcs/docker-compose.yml down -v

re:		clean
		$(MAKE) all

clean:
		docker compose -f srcs/docker-compose.yml down --volumes --rmi all
		sudo rm -rf $(WP_VOLUME_PATH) $(MARIADB_VOLUME_PATH)

$(WP_VOLUME_PATH):
		mkdir -p $(WP_VOLUME_PATH) 

$(MARIADB_VOLUME_PATH):
		mkdir -p $(MARIADB_VOLUME_PATH)

ls:
	@echo "$(_GREEN)------------------------List running containers-------------------------$(_END)"
	$(DOCKER_COMPOSE) ps
	@echo "$(_GREEN)------------------------------List images-------------------------------$(_END)"
	docker images
	@echo "$(_GREEN)------------------------------List volumes------------------------------$(_END)"
	docker volume ls

prune: clean
	@echo "$(_GREEN)Removes all unused images, containers, networks and volumes$(_END)"
	sudo docker system prune -f -a
# -f = force the removal without confirmation
# -a = remove all objects including unused

.PHONY: all re down clean fclean ls prune
