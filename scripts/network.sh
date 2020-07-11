#!/bin/bash

#Add binary path
export PATH=${PWD}/../bin:${PWD}:$PATH

which peer
if [ "$?" -ne 0 ]; then
    echo -e "\e[91mpeer tool not found. exiting\e[39m"
    echo ""
    echo -e "\e[34mPlease run bootstrap.sh -s -d \e[39m"
    exit 1
fi

IMAGETAG="latest"
COMPOSE_FILE_BASE=$(realpath ../config/docker/docker-compose-peer.yaml)
COMPOSE_FILE_COUCH=$(realpath ../config/docker/docker-compose-couch.yaml)

IMAGE_TAG=$IMAGETAG docker-compose -f "$COMPOSE_FILE_BASE" -f "$COMPOSE_FILE_COUCH" up -d 2>&1
docker ps -a 
if [ $? -ne 0 ]; then
  echo -e "\e[91mERROR !!!! Unable to start network\e[39m"
  exit 1
fi
