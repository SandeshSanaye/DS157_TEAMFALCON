#!/bin/bash

#Add binary path
export PATH=${PWD}/../bin:${PWD}:$PATH

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