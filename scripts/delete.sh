IMAGETAG="latest"
COMPOSE_FILE_CA=../config/docker/docker-compose-ca.yaml
IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_CA down -v 2>&1
COMPOSE_FILE_BASE=../config/docker/docker-compose-peer.yaml
COMPOSE_FILE_COUCH=../config/docker/docker-compose-couch.yaml
IMAGE_TAG=$IMAGETAG docker-compose -f "$COMPOSE_FILE_BASE" -f "$COMPOSE_FILE_COUCH" down -v 2>&1
docker image rm --force $(docker images | awk '{print $1}' | grep '^dev-peer')
rm -rf ../channel-artifacts
rm -Rf ../organizations/peerOrganizations && rm -Rf ../organizations/ordererOrganizations
rm -rf ../system-genesis-block

rm -rf ../organizations/fabric-ca/map/msp ../organizations/fabric-ca/map/tls-cert.pem ../organizations/fabric-ca/map/ca-cert.pem ../organizations/fabric-ca/map/IssuerPublicKey ../organizations/fabric-ca/map/IssuerRevocationPublicKey ../organizations/fabric-ca/map/fabric-ca-server.db
rm -rf ../organizations/fabric-ca/registrar/msp ../organizations/fabric-ca/registrar/tls-cert.pem ../organizations/fabric-ca/registrar/ca-cert.pem ../organizations/fabric-ca/registrar/IssuerPublicKey ../organizations/fabric-ca/registrar/IssuerRevocationPublicKey ../organizations/fabric-ca/registrar/fabric-ca-server.db
rm -rf ../organizations/fabric-ca/revenue/msp ../organizations/fabric-ca/revenue/tls-cert.pem ../organizations/fabric-ca/revenue/ca-cert.pem ../organizations/fabric-ca/revenue/IssuerPublicKey ../organizations/fabric-ca/revenue/IssuerRevocationPublicKey ../organizations/fabric-ca/revenue/fabric-ca-server.db
rm -rf ../organizations/fabric-ca/welfare/msp ../organizations/fabric-ca/welfare/tls-cert.pem ../organizations/fabric-ca/welfare/ca-cert.pem ../organizations/fabric-ca/welfare/IssuerPublicKey ../organizations/fabric-ca/welfare/IssuerRevocationPublicKey ../organizations/fabric-ca/welfare/fabric-ca-server.db
rm -rf ../organizations/fabric-ca/orderer/msp ../organizations/fabric-ca/orderer/tls-cert.pem ../organizations/fabric-ca/orderer/ca-cert.pem ../organizations/fabric-ca/orderer/IssuerPublicKey ../organizations/fabric-ca/orderer/IssuerRevocationPublicKey ../organizations/fabric-ca/orderer/fabric-ca-server.db    

rm -rf get-cc-installed
rm -rf get-cc-info

cd ..
docker-compose down -v
docker network rm landrecord_test