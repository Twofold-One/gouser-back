include .envrc

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

.PHONY: confirm 
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## run/api: run the cmd/api application
.PHONY: run/api 
run/api:
	go run ./cmd/api -db-dsn=${GOUSER_DB_DSN}

## db/psql: connect to the database using psql
.PHONY: db/psql 
db/psql:
	psql ${GOUSER_DB_DSN}

## db/migrations/new name=$1: create a new database migration
.PHONY: db/migrations/new 
db/migrations/new:
	@echo 'Creating migration files for ${name}'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

## db/miagratioins/up: apply all up database migrations
.PHONY: db/migrations/up 
db/migrations/up: confirm
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${GOUSER_DB_DSN} up

## db/miagratioins/down: apply all down database migrations
.PHONY: db/migrations/down
db/migrations/down: confirm
	@echo 'Running down migrations...'
	migrate -path ./migrations -database ${GOUSER_DB_DSN} down