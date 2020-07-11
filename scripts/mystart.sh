IMAGE_TAG="latest"
COMPOSE_FILE_BASE=$(realpath ../config/docker/docker-compose-peer.yaml)
COMPOSE_FILE_COUCH=$(realpath ../config/docker/docker-compose-couch.yaml)
COMPOSE_FILE_CA=../config/docker/docker-compose-ca.yaml
IMAGE_TAG=$IMAGETAG docker-compose -f "$COMPOSE_FILE_BASE" -f "$COMPOSE_FILE_COUCH" start 2>&1
IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_CA start 2>&1
cd ..
docker-compose start