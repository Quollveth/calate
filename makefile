include .env
export $(shell sed 's/=.*//' .env)

FRONT_DIR := front
BACK_DIR := back
OUTPUT_DIR := output

GIT_HASH := $(shell git log --format="%h" -n 1)
APPNAME_LOWER := $(shell echo $(APPNAME) | tr 'A-Z' 'a-z')
TAG := $(APPNAME_LOWER):$(GIT_HASH)

export

.PHONY: local clean_local front back docker clean_dock front_dock dock_run move_front check_root dock_serv services clean_all help

help:
	$(info Available rules:)
	$(info local - builds the application locally, also runs services rule)
	$(info services - builds and runs postgres and redis containers)
	$(info docker - builds and runs the application in docker containers)
	$(info clean_local - cleans local build files)
	$(info clean_dock - removes docker containers, images, networks and volumes created by application)
	$(info clean_all - runs clean_local and clean_dock rules)
	$(info All rules require sudo or root privileges to interact with the docker daemon)

# server expects a dit directory on the same directory as executable

local: clean_local front back check_root dock_serv
docker: check_root front_dock dock_run
services: check_root dock_serv
clean_all: clean_local clean_dock

# local

clean_local:
	$(info Clean)
	rm -rf $(OUTPUT_DIR)/*
	rm -fr $(BACK_DIR)/dist

front:
	$(info Frontend)
	rm -fr $(OUTPUT_DIR)/dist
	rm -fr $(FRONT_DIR)/dist

	cd $(FRONT_DIR) && npm run build

	mkdir -p $(OUTPUT_DIR)/dist
	mv $(FRONT_DIR)/dist $(OUTPUT_DIR)/dist

back:
	$(info Backend)
	cd $(BACK_DIR) && go build -o ../$(OUTPUT_DIR)/$(APPNAME)

# docker

dock_serv:
	$(info Docker Services)
	docker compose up redis db

check_root:
	$(info Check Root)
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "This operation must be run as root. Use sudo."; \
		exit 1; \
	fi

dock_run:
	$(info Docker Run)
	docker compose up

clean_dock:
	$(info Clean Docker)

	docker rm $(shell sudo docker ps -a | grep $(APPNAME_LOWER)| awk '{print $1}')
	docker network rm $(shell sudo docker network ls | grep calate | awk '{print $1}')
	docker volume rm $(shell sudo docker volume ls | grep calate | awk '{print $2}')
	docker rmi $(shell sudo docker image ls | grep $(APPNAME_LOWER) | awk '{print $3}')

front_dock: front move_front

move_front:
	$(info Move Frontend)
	rm -fr $(BACK_DIR)/dist
	mv $(OUTPUT_DIR)/dist $(BACK_DIR)/dist
