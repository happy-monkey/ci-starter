PROJECT_DIR=$(shell basename $(CURDIR))
PROJECT_NAME=${PROJECT_DIR}
CONTAINER_NAME=${PROJECT_DIR}-app
FONTAWESOME_NPM_AUTH_TOKEN?=$(shell bash -c 'read -p "FONTAWESOME_NPM_AUTH_TOKEN: " token; echo $$token')

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Assets
yarn: ## Update yarn dependencies
	docker run --rm --env FONTAWESOME_NPM_AUTH_TOKEN=$(FONTAWESOME_NPM_AUTH_TOKEN) \
		--volume $(PWD):/usr/src/app \
		-w /usr/src/app \
		happymonkey/node-sass /bin/sh \
		-c 'yarn install'

sass: ## Generate CSS files from SCSS files
	docker run --rm \
		--volume $(PWD):/usr/src/app \
		-w /usr/src/app \
		happymonkey/node-sass /bin/sh \
		-c 'sass --load-path=public/vendor --style=compressed public/assets/scss/:public/assets/css/'

assets: yarn sass ## Update yarn dependencies and generate CSS from SCSS files

# Composer
composer-install: ## Run composer install
	docker run --rm --interactive --tty \
      --volume $(PWD):/app \
      composer install --ignore-platform-reqs --no-scripts

composer-update: ## Run composer update
	docker run --rm --interactive --tty \
      --volume $(PWD):/app \
      composer update --ignore-platform-reqs --no-scripts

composer-require:
	docker run --rm --interactive --tty \
      --volume $(PWD):/app \
      composer require $(shell bash -c 'read -p "Package name: " package; echo $$package') --ignore-platform-reqs --no-scripts

composer-remove:
	docker run --rm --interactive --tty \
      --volume $(PWD):/app \
      composer remove $(shell bash -c 'read -p "Package name: " package; echo $$package') --ignore-platform-reqs --no-scripts

composer-info:
	docker run --rm --interactive --tty \
      --volume $(PWD):/app \
      composer show -t

# Docker
build: ## Build docker image from Dockerfile
	docker compose --project-directory docker --project-name ${PROJECT_NAME} build

up: ## Run server from ./docker/docker-compose.yml
	docker compose --project-directory docker --project-name ${PROJECT_NAME} up

down:
	docker compose --project-directory docker --project-name ${PROJECT_NAME} down

kill: ## Kill running server
	docker stop `docker ps -a -q --filter name=${PROJECT_DIR}`

exec:
	docker exec -it ${CONTAINER_NAME} /bin/bash

restart: kill up ## Restart running server

# Project
init: assets build composer-install
