#!/bin/bash

#Add binary path
export PATH=${PWD}/../bin:${PWD}:$PATH

export FABRIC_CFG_PATH=${PWD}/../config/configtx

which configtxgen
if [ "$?" -ne 0 ]; then
  echo -e "\e[91mconfigtxgen not found. exiting\e[39m"
  echo ""
  echo -e "\e[34mPlease run bootstrap.sh -s -d \e[39m"
  exit 1
fi

echo -e "\e[34m##########################################################"
echo -e "###########Generating Orderer Genesis block###############"
echo -e "##########################################################\e[39m"

# Note: For some unknown reason (at least for now) the block file can't be
# named orderer.genesis.block or the orderer will fail to launch!
set -x
configtxgen -profile LandRecordOrdererGenesis -channelID landrecord -outputBlock ../system-genesis-block/genesis.block
res=$?
set +x
if [ $res -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi