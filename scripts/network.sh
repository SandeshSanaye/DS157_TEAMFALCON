#!/bin/bash
#
#SPDX-License-Identifier: Apache-2.0
#

#Add binary path
export PATH=${PWD}/../bin:${PWD}:$PATH

# Versions of fabric known not to work with this scripts
BLACKLISTED_VERSIONS="^1\.0\. ^1\.1\. ^1\.2\. ^1\.3\. ^1\.4\."

# Print the usage message
function printHelp() {
  echo "Usage: "
  echo "  network.sh [Flags]"
  echo "    Flags:"
  echo "    -p <peer> name of docker yaml defination for peers"
  echo "    -s <storage> name of docker yaml defination for couchdb (bydefalut us LevelDB)"
  echo "    -i <imagetag> - the tag to be used to launch the network (defaults to \"latest\")"
  echo "  network.sh -h (print this message)"
  echo
  echo " Examples:"
  echo "  network.sh -p peer.yaml -s couchdb.yaml -i 2.1.0"
}

# Do some basic sanity checking to make sure that the appropriate versions of fabric
# binaries/images are available.
function checkPrereqs() {
  ## Check if your have cloned the peer binaries and configuration files.
  peer version > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo "ERROR! Peer binary not found.."
    echo
    echo "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
    echo "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
    exit 1
  fi

  # use the fabric tools container to see if the samples and binaries match your
  # docker images
  LOCAL_VERSION=$(peer version | sed -ne 's/ Version: //p')
  DOCKER_IMAGE_VERSION=$(docker run --rm hyperledger/fabric-tools:$IMAGETAG peer version | sed -ne 's/ Version: //p' | head -1)
  echo "LOCAL_VERSION=$LOCAL_VERSION"
  echo "DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION"

  if [ "$LOCAL_VERSION" != "$DOCKER_IMAGE_VERSION" ]; then
    echo "=================== WARNING ==================="
    echo "  Local fabric binaries and docker images are  "
    echo "  out of  sync. This may cause problems.       "
    echo "==============================================="
  fi

  for UNSUPPORTED_VERSION in $BLACKLISTED_VERSIONS; do
    echo "$LOCAL_VERSION" | grep -q $UNSUPPORTED_VERSION
    if [ $? -eq 0 ]; then
      echo "ERROR! Local Fabric binary version of $LOCAL_VERSION does not match the versions supported by the test network."
      exit 1
    fi

    echo "$DOCKER_IMAGE_VERSION" | grep -q $UNSUPPORTED_VERSION
    if [ $? -eq 0 ]; then
      echo "ERROR! Fabric Docker image version of $DOCKER_IMAGE_VERSION does not match the versions supported by the test network."
      exit 1
    fi
  done
}

function networkUp() {

  checkPrereqs
  
  # generate artifacts if they don't exist
  if [ ! -d "../organizations/peerOrganizations" ]; then
    ./cryptogen.sh
    ./configtx.sh
  fi

  if [ "${DATABASE}" == "couchdb" ]; then
  IMAGE_TAG=$IMAGETAG docker-compose -f "$COMPOSE_FILE_BASE" -f "$COMPOSE_FILE_COUCH" up -d 2>&1
  docker ps -a 
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start network"
    exit 1
  fi
  else
  IMAGE_TAG=$IMAGETAG docker-compose -f "$COMPOSE_FILE_BASE" up -d 2>&1
  docker ps -a
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start network"
    exit 1
  fi
  fi
}

# default image tag
IMAGETAG="latest"

# Check for flags
while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  -h )
    printHelp
    exit 0
    ;;
  -p )
    COMPOSE_FILE_BASE=$(realpath ../config/docker/"$2")
    shift
    ;;
  -s )
    COMPOSE_FILE_COUCH=$(realpath ../config/docker/"$2")
    DATABASE="couchdb"
    shift
    ;;
  -i )
    IMAGETAG="$2"
    shift
    ;;
  * )
    echo
    echo "Unknown flag: $key"
    echo
    printHelp
    exit 1
    ;;
  esac
  shift
done

networkUp