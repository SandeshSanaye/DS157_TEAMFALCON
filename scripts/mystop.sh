IMAGE_TAG="latest"
COMPOSE_FILE_BASE=$(realpath ../config/docker/docker-compose-peer.yaml)
COMPOSE_FILE_COUCH=$(realpath ../config/docker/docker-compose-couch.yaml)
COMPOSE_FILE_CA=../config/docker/docker-compose-ca.yaml
IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_CA stop 2>&1
IMAGE_TAG=$IMAGETAG docker-compose -f "$COMPOSE_FILE_BASE" -f "$COMPOSE_FILE_COUCH" stop 2>&1
cd ..
docker-compose stop