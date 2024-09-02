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

.PHONY: migrate-down
migrate-down:
	DATABASE_URL=$(DATABASE_HOST)/$(RDB_NAME) dbmate -d db_schema/migrations -s db_schema/schema.sql down

.PHONY: migrate-drop
migrate-drop:
	DATABASE_URL=$(DATABASE_HOST)/$(RDB_NAME) dbmate -d db_schema/migrations -s db_schema/schema.sql drop

.PHYONY: gen-dbmodel
gen-dbmodel:
	go run -mod=mod github.com/xo/xo schema mysql://$(RDB_USER):$(RDB_PASSWORD)@$(RDB_HOST):$(RDB_PORT)/$(RDB_NAME) --out db_model -e *.created_at -e *.updated_at --src db_model/templates/go

.PHYONY: clean-dbmodel
clean-dbmodel:
	rm -rf db_model/*.xo.go
