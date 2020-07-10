export PATH=${PWD}/../bin:${PWD}:$PATH

IMAGETAG="latest"
COMPOSE_FILE_CA=../config/docker/docker-compose-ca.yaml
IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_CA up -d 2>&1
. ../organizations/fabric-ca/register-enroll.sh

    sleep 10

    echo "##########################################################"
    echo "############ Create Org1 Identities ######################"
    echo "##########################################################"

    createmap

    echo "##########################################################"
    echo "############ Create Org2 Identities ######################"
    echo "##########################################################"

    createregistrar

    echo "##########################################################"
    echo "############ Create Org3 Identities ######################"
    echo "##########################################################"

    createrevenue

    echo "##########################################################"
    echo "############ Create Org4 Identities ######################"
    echo "##########################################################"

    createwelfare

    echo "##########################################################"
    echo "############ Create Orderer Org Identities ###############"
    echo "##########################################################"

    createOrderer

../organizations/ccp-generate.sh