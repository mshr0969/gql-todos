include .env

.PHONY: gen
gen:
	gqlgen

.PHONY: up
up:
	docker-compose up -d

.PHONY: down
down:
	docker-compose down

MIGRATION_COMMENT ?= $(shell bash -c 'read -p "Migration comment: " pwd; echo $$pwd')
.PHONY: migrate-new
migrate-new:
	DATABASE_URL=$(DATABASE_HOST)/$(RDB_NAME) dbmate -d db_schema/migrations -s db_schema/schema.sql new $(MIGRATION_COMMENT)

.PHONY: migrate-up
migrate-up:
	DATABASE_URL=$(DATABASE_HOST)/$(RDB_NAME) dbmate -d db_schema/migrations -s db_schema/schema.sql up
