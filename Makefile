COMPOSE  = docker compose -f  srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data
all: up

up: 
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop $(SERVICE)

kill:
	$(COMPOSE) kill $(SERVICE)

start:
	$(COMPOSE) start $(SERVICE)

logs:
	$(COMPOSE) logs -f $(SERVICE)

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down --rmi all --volumes --remove-orphans

fclean: clean
	sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all up down stop kill start logs ps clean fclean re
