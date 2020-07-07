COMPOSE_FILE_BASE=$(realpath ../config/docker/docker-compose-peer.yaml)
COMPOSE_FILE_COUCH=$(realpath ../config/docker/docker-compose-couch.yaml)
COMPOSE_FILE_CA=$(realpath ../config/docker/docker-compose-ca.yaml)

docker-compose -f $COMPOSE_FILE_BASE -f $COMPOSE_FILE_COUCH -f $COMPOSE_FILE_CA down --volumes --remove-orphans

# Bring down the network, deleting the volumes
#Cleanup the chaincode containers
clearContainers
#Cleanup images
removeUnwantedImages
# remove orderer block and other channel configuration transactions and certs
rm -rf ../system-genesis-block/*.block ../organizations/peerOrganizations ../organizations/ordererOrganizations
## remove fabric ca artifacts
rm -rf ../organizations/fabric-ca/org1/msp ../organizations/fabric-ca/org1/tls-cert.pem
../organizations/fabric-ca/org1/ca-cert.pem ../organizations/fabric-ca/org1/IssuerPublicKey
../organizations/fabric-ca/org1/IssuerRevocationPublicKey ../organizations/fabric-ca/org1/fabric-ca-server.db
rm -rf ../organizations/fabric-ca/org2/msp ../organizations/fabric-ca/org2/tls-cert.pem
../organizations/fabric-ca/org2/ca-cert.pem ../organizations/fabric-ca/org2/IssuerPublicKey
../organizations/fabric-ca/org2/IssuerRevocationPublicKey ../organizations/fabric-ca/org2/fabric-ca-server.db
rm -rf ../organizations/fabric-ca/ordererOrg/msp ../organizations/fabric-ca/ordererOrg/tls-cert.pem
../organizations/fabric-ca/ordererOrg/ca-cert.pem ../organizations/fabric-ca/ordererOrg/IssuerPublicKey
../organizations/fabric-ca/ordererOrg/IssuerRevocationPublicKey ../organizations/fabric-ca/ordererOrg/fabric-ca-server.db



# remove channel and script artifacts
rm -rf ../channel-artifacts log.txt fabcar.tar.gz fabcar


function clearContainers() {
    CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
    if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
        echo "---- No containers available for deletion ----"
    else
        docker rm -f $CONTAINER_IDS
    fi
}

function removeUnwantedImages() {
DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
echo "---- No images available for deletion ----"
else
docker rmi -f $DOCKER_IMAGE_IDS
fi
}