.DEFAULT_GOAL := help
SHELL := /bin/bash


##@ App

.PHONY: fixtures
fixtures: ## Recreate test fixtures
	rm -Rf ./tests/fixtures
	./gh-repo-config init --config ./tests/fixtures

.PHONY: format
format: ## Format source code
	@echo "TODO..."

.PHONY: lint
lint: ## Lint source code
	@echo "TODO..."

.PHONY: test
test: export APP_ENV := test
test: ## Test the extension
	./vendor/bats-core/bin/bats ./tests/

.PHONY: run
run: ## Run the extension
	@./gh-repo-config

.PHONY: install
install: ## Install the extension
	gh extension install .


##@ Other

.PHONY: setup
setup: ## Bootstrap for local development
	git submodule update --init --recursive

# Via https://www.thapaliya.com/en/writings/well-documented-makefiles/
# Note: The `##@` comments determine grouping
.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""
