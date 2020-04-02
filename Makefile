PROJECT_DIR=$(shell basename $(CURDIR))
CONTAINER_NAME=${PROJECT_DIR}_app_1

# Assets
yarn:
	yarn install

sass:
	sass --load-path=public/vendor --style=compressed public/assets/scss/:public/assets/css/

watch:
	sass --load-path=public/vendor --watch --style=compressed public/assets/scss/:public/assets/css/

assets: yarn sass

# Database
migration-generate:
	docker exec -ti ${CONTAINER_NAME} sh -c "vendor/bin/phinx-migrations generate --overwrite"

migration-migrate:
	docker exec -ti ${CONTAINER_NAME} sh -c "vendor/bin/phinx-migrations migrate"

# Docker
build:
	rm -f .env
	docker-compose build

up:
	rm -f .env
	docker-compose up --force-recreate