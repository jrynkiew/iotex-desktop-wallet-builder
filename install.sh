#!/bin/bash
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# Start of script - getting necessary user input
read -p "Do you want to build Alpine (${red}A${reset}) or Ubuntu (${green}U${reset}) AppImage/Snap binaries?: " MODE
MODE_flag=$(case "$MODE" in
  (A|a)    echo "alpine"  ;;
  (U|u)    echo "ubuntu"  ;;
  ( * )    echo "Error. Wrong Selection"  ;;
esac)

docker-compose -f build/docker-compose.yml build iotex-explorer-builder-$MODE_flag

docker-compose -f build/docker-compose.yml up iotex-explorer-builder-$MODE_flag
