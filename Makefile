#!/bin/bash

UID = $(shell id -u)
DOCKER_BE = symfony-app


start: ## Start the containers
	docker network create symfony-network || true
	U_ID=${UID} docker compose up -d

down:
	U_ID=${UID} docker compose down

stop: ## Stop the containers
	U_ID=${UID} docker compose stop

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start

build: ## Rebuilds all the containers
	docker network create symfony-network || true
	U_ID=${UID} docker compose build

prepare: ## Runs backend commands
	$(MAKE) composer-install

run: ## starts the Symfony development server in detached mode
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} symfony serve -d

logs: ## Show Symfony logs in real time
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} symfony server:log


comp-ins:
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_BE} composer install --no-interaction

ssh: ## bash into the be container
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} bash
