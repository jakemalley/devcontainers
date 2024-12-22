BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo no-commit-id)

IMAGE_NAME := dev-go

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
	@echo IMAGE_NAME = $(IMAGE_NAME)
	@echo WORKSPACE = $(WORKSPACE)
	@echo PKG = $(PKG)

##@ Build

.PHONY: build
build: ## Build the devcontainer image
	docker build -t $(IMAGE_NAME):$(BUILD_ID) .

.PHONY: release
release: build ## Build the devcontainer image and tag it as latest
	docker tag $(IMAGE_NAME):$(BUILD_ID) $(IMAGE_NAME):latest

