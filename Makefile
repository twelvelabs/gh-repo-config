.DEFAULT_GOAL := help
SHELL := /bin/bash


##@ App

.PHONY: fixtures
fixtures: ## Recreate test fixtures
	rm -Rf ./tests/fixtures
	./gh-repo-config init --config ./tests/fixtures
	cp ./tests/fixtures/branch-protection/main.json ./tests/fixtures/branch-protection/prod.json

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

.PHONY: release
release: ## Create a new GitHub release
	git fetch --all --tags
	@if ! command -v svu >/dev/null 2>&1; then echo "Unable to find svu!"; exit 1; fi
	@if [[ "$$(svu next)" == "$$(svu current)" ]]; then echo "Nothing to release!" && exit 1; fi
	gh release create "$$(svu next)" --generate-notes


##@ Other

.PHONY: setup
setup: ## Bootstrap for local development
	@if ! command -v gh >/dev/null 2>&1; then echo "Unable to find gh!"; exit 1; fi
	@if ! command -v git >/dev/null 2>&1; then echo "Unable to find git!"; exit 1; fi
	git submodule update --init --recursive

# Via https://www.thapaliya.com/en/writings/well-documented-makefiles/
# Note: The `##@` comments determine grouping
.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""
