DOCKER_COMPOSE ?= docker compose
KIRBY_PORT ?= 8080
KIRBY_SITE_URL ?= http://localhost:$(KIRBY_PORT)
KIRBY_VERSION ?= ^5
IFRAME_URL ?= /iframe-target

export KIRBY_PORT
export KIRBY_SITE_URL
export KIRBY_VERSION
export IFRAME_URL

.DEFAULT_GOAL := help

.PHONY: help install dev watch build test docker-config docker-build docker-up docker-up-kirby4 docker-up-kirby6 docker-down docker-reset

help:
	@echo "Available targets:"
	@echo "  make install          Install npm dependencies"
	@echo "  make dev              Start kirbyup dev server"
	@echo "  make watch            Build Panel assets and watch for changes"
	@echo "  make build            Build Panel assets"
	@echo "  make test             Run local build and Docker Compose config checks"
	@echo "  make docker-config    Validate Docker Compose configuration"
	@echo "  make docker-build     Build the Docker test image"
	@echo "  make docker-up        Start the Docker test environment"
	@echo "  make docker-up-kirby4 Reset and start the Docker test environment with Kirby 4"
	@echo "  make docker-up-kirby5 Reset and start the Docker test environment with Kirby 5"
	@echo "  make docker-up-kirby6 Reset and start the Docker test environment with Kirby 6 preview"
	@echo "  make docker-down      Stop the Docker test environment"
	@echo "  make docker-reset     Remove the Docker test environment and Kirby volume"

install:
	npm install

dev:
	npm run dev

watch:
	npm run watch

build:
	npm run build

test: build docker-config

docker-config:
	$(DOCKER_COMPOSE) config

docker-build:
	$(DOCKER_COMPOSE) build

docker-up:
	$(DOCKER_COMPOSE) up --build

docker-up-kirby4:
	$(DOCKER_COMPOSE) down -v
	KIRBY_VERSION="^4" $(DOCKER_COMPOSE) up --build

docker-up-kirby5:
	$(DOCKER_COMPOSE) down -v
	KIRBY_VERSION="^5" $(DOCKER_COMPOSE) up --build

docker-up-kirby6:
	$(DOCKER_COMPOSE) down -v
	KIRBY_VERSION="^6.0@alpha" $(DOCKER_COMPOSE) up --build

docker-down:
	$(DOCKER_COMPOSE) down

docker-reset:
	$(DOCKER_COMPOSE) down -v
