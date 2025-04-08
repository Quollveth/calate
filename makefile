include .env
export $(shell sed 's/=.*//' .env)

FRONT_DIR := front
BACK_DIR := back
OUTPUT_DIR := output

GIT_HASH := $(shell git log --format="%h" -n 1)
APPNAME_LOWER := $(shell echo $(APPNAME) | tr 'A-Z' 'a-z')
TAG := $(APPNAME_LOWER):$(GIT_HASH)

export

.PHONY: local clean front back docker clean_dock front_dock back_dock dock_run move_front check_root

# local

local: clean front back

clean:
	rm -rf $(OUTPUT_DIR)/*

front:
	# server expects a dit directory on the same directory as executable
	rm -fr $(OUTPUT_DIR)/dist
	rm -fr $(FRONT_DIR)/dist

	cd $(FRONT_DIR) && npm run build

	mkdir -p $(OUTPUT_DIR)
	cp -r $(FRONT_DIR)/dist $(OUTPUT_DIR)/dist

back:
	cd $(BACK_DIR) && go build -o ../$(OUTPUT_DIR)/$(APPNAME)

# docker

docker: check_root front_dock back_dock dock_run

check_root:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "This operation must be run as root. Use sudo."; \
		exit 1; \
	fi

dock_run:
	docker compose up

clean_dock:
	docker rmi $(shell sudo docker image ls | grep $(APPNAME_LOWER) | awk '{print $3}')
	rm -fr $(BACK_DIR)/dist

front_dock: front move_front

move_front:
	# when the dockerfile does COPY . ./ it will pick dist as well
	cp -r $(OUTPUT_DIR)/dist $(BACK_DIR)/dist
	rm -fr $(OUTPUT_DIR)/dist

back_dock:
	cd $(BACK_DIR) && \
