#!/bin/bash
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

docker-compose -f build/docker-compose.yml up --build --no-deps --remove-orphans
