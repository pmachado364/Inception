NAME = inception
COMPOSE = srcs/docker-compose.yml

LOGIN = $(shell whoami)
DOMAIN_NAME = $(LOGIN).42.fr

DATA_PATH = /home/$(LOGIN)/data
WP_PATH = $(DATA_PATH)/wordpress
DB_PATH = $(DATA_PATH)/database

export LOGIN
export DOMAIN_NAME
export WP_PATH
export DB_PATH

all: up

create_directories:
	mkdir -p $(WP_PATH) $(DB_PATH)

up: create_directories
	docker compose -f $(COMPOSE) -p $(NAME) up --build -d

down:
	docker compose -f $(COMPOSE) -p $(NAME) down

clean:
	docker compose -f $(COMPOSE) -p $(NAME) down -v

fclean: clean
	sudo rm -rf $(DB_PATH)
	sudo rm -rf $(WP_PATH)

re: fclean up

logs:
	docker compose -f $(COMPOSE) -p $(NAME) logs -f

.PHONY: all up down clean fclean re create_directories logs