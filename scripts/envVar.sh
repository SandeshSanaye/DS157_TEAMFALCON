#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/msp/tlscacerts/tlsca.landrecord.com-cert.pem
export PEER0_map_CA=${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/ca.crt
export PEER0_registrar_CA=${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/ca.crt
export PEER0_revenue_CA=${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/ca.crt
export PEER0_welfare_CA=${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/ca.crt


# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/ordererOrganizations/landrecord.com/orderers/orderer.landrecord.com/msp/tlscacerts/tlsca.landrecord.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/ordererOrganizations/landrecord.com/users/Admin@landrecord.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  echo "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="mapMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_map_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/map.landrecord.com/users/Admin@map.landrecord.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="registrarMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_registrar_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/users/Admin@registrar.landrecord.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="revenueMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_revenue_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/users/Admin@revenue.landrecord.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="welfareMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_welfare_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/welfare.com/users/Admin@welfare.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
  
  else
    echo "================== ERROR !!! ORG Unknown =================="
    exit 1
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer adresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}
