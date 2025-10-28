BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo no-commit-id)

.DEFAULT_GOAL := help

##@ General

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: id
id: ## Output BUILD_ID being used
	@echo $(BUILD_ID)

.PHONY: debug
debug: ## Output internal make variables
	@echo BUILD_ID = $(BUILD_ID)
	@echo WORKSPACE = $(WORKSPACE)
	@echo PKG = $(PKG)

##@ Build

.PHONY: build
build: ## Build the devcontainer image
	IMAGE_TAG=$(BUILD_ID) docker-compose build

.PHONY: release
release: build ## Build the devcontainer image and tag it as latest
	IMAGE_TAG=latest docker-compose build

##@ Debug

.PHONY: shell
shell: ## Run a shell in the image
	docker run --rm -it -u code dev-base:$(BUILD_ID) zsh