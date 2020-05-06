PROJECT_DIR=$(shell basename $(CURDIR))
CONTAINER_NAME=${PROJECT_DIR}_app_1

ifndef FONTAWESOME_NPM_AUTH_TOKEN
	$(error FONTAWESOME_NPM_AUTH_TOKEN is not set)
endif

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Assets
yarn: ## Update yarn dependencies
	docker run --rm -e FONTAWESOME_NPM_AUTH_TOKEN \
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

# Database
migration-generate: ## Generate migration from current database
	docker exec -ti ${CONTAINER_NAME} \
		sh -c "vendor/bin/phinx-migrations generate --overwrite"

migration-migrate: ## Apply migrations
	docker exec -ti ${CONTAINER_NAME} \
		sh -c "vendor/bin/phinx-migrations migrate"

# Docker
prepare:
	rm -f .env

build: prepare ## Build docker image from Dockerfile
	docker-compose build

up: prepare ## Run server from docker-compose.yml
	docker-compose up --force-recreate

kill: ## Kill running server
	docker stop `docker ps -a -q --filter name=${PROJECT_DIR}`

down: kill

exec:
	docker exec -it ${CONTAINER_NAME} /bin/bash

restart: kill up ## Restart running server

# Project
install: assets composer-install
