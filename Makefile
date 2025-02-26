env: ## Start required containers: postgres and ruby
	@docker compose up -d

up: env ## alias for env

build: ## Re-build ruby container (if Dockerfile changes)
	@docker compose build

.docker-build: docker/Dockerfile
	@docker compose build
	@touch $@

bundle: env ## Run `bundle install` if necessary
	@docker compose exec api bash -c "bundle check || bundle install"

db_prepare: env ## Ensure database is created, migrated, and seeded
	@docker compose exec api bin/rails db:create
	@docker compose exec api bin/rails db:migrate:with_data
	@docker compose exec api bin/rails db:seed

prepare_all: .docker-build env bundle db_prepare

s: ## Fast start bash shell without environment checks
	@docker compose exec -it api bash

shell: prepare_all s ## Ensure environment is up and running and drop into shell in ruby container

rails: ## Start the rails server
	@docker compose exec api bin/rails s -p 3000 --binding=0.0.0.0

start: prepare_all rails ## Build and start full environment, run bundle install, ensure db is ready, and start rails server

specs: # Run rspec
	@docker compose exec api bundle exec rspec spec

test: .docker-build env bundle specs ## Ensure environment is up to date and spun up and run rspec

g: ## Fast start guard without environment checks
	@docker compose exec -it api bundle exec guard

guard: prepare_all g ## Ensure environment is running and run guard to run tests

c: ## Fast start the rails console without environment checks
	@docker compose exec -it api bin/rails c

console: prepare_all c ## Ensure environment is running and spin up the rails console

down: ## Shut down containers
	@docker compose down

coverage: test ## Run the full test suite and open up the code coverage report
	open coverage/index.html

psql: # Start psql on command line
	docker compose run psql

sidekiq: ## Start sidekiq on command line
	@docker compose exec -it sidekiq bash -c "( bundle check || bundle install ) && bundle exec sidekiq"

mb_consumer: prepare_all ## Start sidekiq on command line
	@docker compose exec -it api bash -c "script/platform_message_bus run"

annotate_models: ## Annotate models
	@docker compose exec -it api bin/rails annotate_models


help: ## Print out this help message
	@egrep "^([a-zA-Z0-9_-]+):(.*)*##[[:blank:]]*(.*)" $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
