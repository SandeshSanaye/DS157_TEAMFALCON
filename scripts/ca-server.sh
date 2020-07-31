export PATH=${PWD}/../bin:${PWD}:$PATH

IMAGETAG="latest"
COMPOSE_FILE_CA=../config/docker/docker-compose-ca.yaml

which fabric-ca-client
if [ "$?" -ne 0 ]; then
    echo -e "\e[91mfabric-ca-client tool not found. exiting\e[39m"
    echo ""
    echo -e "\e[34mPlease run bootstrap.sh -s -d \e[39m"
    exit 1
fi

which fabric-ca-server
if [ "$?" -ne 0 ]; then
    echo -e "\e[91mfabric-ca-server tool not found. exiting\e[39m"
    echo ""
    echo -e "\e[34mPlease run bootstrap.sh -s -d \e[39m"
    exit 1
fi

echo -e "\e[34m##########################################################"
echo -e "############# Creating Container for Fabric-ca #################"
echo -e "##########################################################\e[39m"

IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_CA up -d 2>&1

. ../organizations/fabric-ca/register-enroll.sh

sleep 10

echo -e "\e[34m##########################################################"
echo -e "############ Create Org1 Identities ######################"
echo -e "##########################################################\e[39m"

createmap

echo -e "\e[34m##########################################################"
echo -e "############ Create Org2 Identities ######################"
echo -e "##########################################################\e[39m"

createregistrar

echo -e "\e[34m##########################################################"
echo -e "############ Create Org3 Identities ######################"
echo -e "##########################################################\e[39m"

createrevenue

echo -e "\e[34m##########################################################"
echo -e "############ Create Org4 Identities ######################"
echo -e "##########################################################\e[39m"

createwelfare

echo -e "\e[34m##########################################################"
echo -e "############ Create Orderer Org Identities ###############"
echo -e "##########################################################\e[39m"

createOrderer

echo -e "\e[34m##########################################################"
echo -e "####################### Create CCP #######################"
echo -e "##########################################################\e[39m"

../organizations/ccp-generate.sh