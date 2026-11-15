COMPOSE =docker compose
COMPOSE_FILE = srcs/docker-compose.yml


build:
	mkdir -p /home/musoysal/data/mysql
	mkdir -p /home/musoysal/data/wordpress
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d
down:
	$(COMPOSE) -f $(COMPOSE_FILE) down
restart:
	$(COMPOSE) -f $(COMPOSE_FILE) down
	$(COMPOSE) -f $(COMPOSE_FILE) up -d
clean:
	$(COMPOSE) -f $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans
logs:
	$(COMPOSE) -f $(COMPOSE_FILE) logs -f
kill:
	$(COMPOSE) -f $(COMPOSE_FILE) kill
stop:
	$(COMPOSE) -f $(COMPOSE_FILE) stop
start:
	$(COMPOSE) -f $(COMPOSE_FILE) start
stopMariaDB:
	$(COMPOSE) -f $(COMPOSE_FILE) stop mariadb
stopWordPress:
	$(COMPOSE) -f $(COMPOSE_FILE) stop wordpress
stopnginx:
	$(COMPOSE) -f $(COMPOSE_FILE) stop nginx
startMariaDB:
	$(COMPOSE) -f $(COMPOSE_FILE) start mariadb
startWordPress:
	$(COMPOSE) -f $(COMPOSE_FILE) start wordpress
startnginx:	
	$(COMPOSE) -f $(COMPOSE_FILE) start nginx

.PHONY: build up down restart  clean logs kill