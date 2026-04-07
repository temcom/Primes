SHELL := /bin/bash

.ONESHELL:

DIRECTORY := $(shell pwd)
# Defaults (can be overridden from environment or `make VAR=value`)
FORMATTER ?= table
TIMEOUT ?= 10
OUTPUT_FILE ?=

.PHONY: all
all: benchmark

.PHONY: benchmark
benchmark: check-env
	@ARGS=("-d" "$(DIRECTORY)" "-f" "$(FORMATTER)"); \
	if [ -n "$(OUTPUT_FILE)" ]; then ARGS+=("-o" "$(OUTPUT_FILE)"); fi; \
	if [ ! -z "$$UNCONFINED" ]; then ARGS+=("--unconfined"); fi; \
	if [ -n "$(TIMEOUT)" ]; then ARGS+=("-t" "$(TIMEOUT)"); fi; \
	cd ./tools && npm ci --silent && npm start --silent -- benchmark "$${ARGS[@]}"

.PHONY: check-env
check-env: check-cc-works check-docker-works check-node-works

.PHONY: check-cc-works
check-cc-works:
	@cc --version >/dev/null 2>&1 || (echo 'Please install a C compiler. See https://github.com/PlummersSoftwareLLC/Primes/blob/drag-race/BENCHMARK.md for more information.' && exit 1)

.PHONY: check-node-works
check-node-works:
	@npm --version >/dev/null 2>&1 || (echo 'Please install Node.js. See https://github.com/PlummersSoftwareLLC/Primes/blob/drag-race/BENCHMARK.md for more information.' && exit 1)

.PHONY: check-docker-works
check-docker-works:
	@docker --version >/dev/null 2>&1 || (echo 'Please install Docker (https://docs.docker.com/get-docker/). See BENCHMARK.md for details.' && exit 1)
	@docker ps >/dev/null 2>&1 || (echo 'Docker does not appear to be running or you lack permission to run docker commands. Try starting the Docker daemon or run `sudo docker ps`.' && exit 1)
