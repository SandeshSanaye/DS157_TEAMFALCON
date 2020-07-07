#!/bin/bash
#
#SPDX-License-Identifier: Apache-2.0
#

#Add binary path
export PATH=${PWD}/../bin:${PWD}:$PATH

#Remove old crypto files if exists
if [ -d "../organizations/peerOrganizations" ]; then
    echo "Removing older crypto files"
    rm -Rf ../organizations/peerOrganizations && rm -Rf ../organizations/ordererOrganizations
fi

#Check binary exits or not
which cryptogen
if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
fi

#Generate crypto files using cryptogen-config files 
FILES="../config/cryptogen/*.yaml
../config/cryptogen/*.yml
"
for cryptogen_config in $FILES ;
    do set -x
    cryptogen generate --config=$cryptogen_config --output="../organizations"
    res=$?
    set +x
    if [ $res -ne 0 ]; then
      echo "Failed to generate certificates..."
      exit 1
    fi ;
done