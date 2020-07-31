#!/bin/bash

# Provides easy access to the chaincode container logs

usage() {
    echo "cc-logs.sh   [-o ORG_NAME default=acme]  [-p PEER_NAME ] [-f   Follow] [-t  Number]"
    echo "              Shows the logs for the chaincode container. "
    echo "              -f follows the logs, useful when debugging in net mode "
    echo "              -t flag is equivalent to --tail flag for docker logs"
    echo "              -h  shows the usage"
}

source cc.env.sh
ORG_NAME=map
PEER_NAME=peer0
LOG_OPTIONS=""
while getopts "o:p:t:fh" OPTION; do
    case $OPTION in
    o)
        ORG_NAME=${OPTARG}
        ;;
    p)
        PEER_NAME=${OPTARG}
        ;;
    f)
        LOG_OPTIONS="$LOG_OPTIONS -f"
        ;;
    t)
        LOG_OPTIONS="$LOG_OPTIONS --tail ${OPTARG}"
        ;;
    h)
        usage
        exit 1
        ;;
    *)
        echo "Incorrect options provided"
        exit 1
        ;;
    esac
done

get-cc-installed.sh
source get-cc-installed &> /dev/null

# CC_CONTAINER_NAME=$INSTALLED_MAX_PACKAGE_ID
INSTALLED_MAX_PACKAGE_ID=$(echo $INSTALLED_MAX_PACKAGE_ID | tr ':' '-' )
CC_CONTAINER_NAME="$PEER_NAME.$ORG_NAME.landrecord.com"
echo $CC_CONTAINER_NAME

#CC_CONTAINER_NAME="$CONTAINER_PREFIX-$PEER_NAME.$ORG_NAME.com-$CC_NAME.$CC_VERSION-$CC2_PACKAGE_ID_HASH"

# cmd="docker logs $LOG_OPTIONS $CC_CONTAINER_NAME"

cmd="docker logs $LOG_OPTIONS $CC_CONTAINER_NAME"

echo "Command: $cmd"

docker logs $LOG_OPTIONS $CC_CONTAINER_NAME 