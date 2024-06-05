
#get env variables from .env
include srcs/.env


# build rule
all:	$(WP_VOLUME_PATH) $(MARIADB_VOLUME_PATH)
		docker compose -f ./srcs/docker-compose.yml up --build

#volume paths
$(WP_VOLUME_PATH):
		mkdir -p $(WP_VOLUME_PATH) 
$(MARIADB_VOLUME_PATH):
		mkdir -p $(MARIADB_VOLUME_PATH)

#down rule
down:
		docker compose -f ./srcs/docker-compose.yml down -v

#utils rules
re:		clean
		$(MAKE) all

clean:
		docker compose -f srcs/docker-compose.yml down --volumes --rmi all
		sudo rm -rf $(WP_VOLUME_PATH) $(MARIADB_VOLUME_PATH)

ls:
	@echo "------------------------List running containers-------------------------"
	docker compose -f srcs/docker-compose.yml ps
	@echo "------------------------------List images-------------------------------"
	docker images
	@echo "------------------------------List volumes------------------------------"
	docker volume ls

prune: clean
	sudo docker system prune -f -a

.PHONY: all re down clean fclean ls prune
