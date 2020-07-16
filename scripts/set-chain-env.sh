#!/usr/bin/env bash

# Sets the environment variables for the chaincode
function usage() {
    echo "Usage: set-chain-env.sh -n name -p path -l lang -v version -C channelId "
    echo "                        -c constructorParams  -q queryParams -i invokeParams"
    echo "                        -R  private data collection"
    echo "                        -s Sequence number            -I  true | false --init-required "
    echo "                        -g Signature Policy           -G  Channel Config Policy"
    echo "                        -R  private data collection   -z  Resets the parameters"
    echo "                        -e map | revenue | registrar       Endorsing peers "
    echo "                        -L log level for chaincode    -S  log level for shim"
    echo "MUST always specify -l with -p"
    echo "-l   golang | node | java"
    echo "-p   Just provide the source folder not full path"
    echo "     golang   Picked from GOPATH=$GOPATH/src"
    echo "To check current setup   cc.env.sh"
}

# 2.0 Resets the variables
function reset_chaincode_variables() {
    CC_LANGUAGE=golang
    CC_PATH=conversion
    CC_NAME=gocc
    CC_VERSION="1.0"
    CC_CHANNEL_ID=landrecords
    CC_CONSTRUCTOR='{"Args":["init","a","100","b","300"]}'
    CC_QUERY_ARGS='{"Args":["query","b"]}'
    CC_INVOKE_ARGS='{"Args":["invoke","a","b","5"]}'
    CORE_CHAINCODE_ID_NAME='gocc'
    CORE_CHAINCODE_LOGGING_LEVEL=''
    CORE_CHAINCODE_LOGGING_SHIM=''
    CC_PRIVATE_DATA_JSON=''
    CC_ENDORSEMENT_POLICY=""
    CC2_SEQUENCE="1"
    CC2_INIT_REQUIRED="true"
    CC2_PACKAGE_FOLDER="/home/vagrant/LRBC"
    CC2_SIGNATURE_POLICY=""
    CC2_CHANNEL_CONFIG_POLICY=""
    CORE_PEER_ADDRESS=localhost:7051
    CORE_PEER_LOCALMSPID="mapMSP"
    INTERNAL_DEV_VERSION="1"
    CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/map.landrecord.com/users/Admin@map.landrecord.com/msp
    CORE_PEER_ID=peer0.landrecord.landrecord.com
    FABRIC_LOGGING_SPEC=info
    ORDERER_ADDRESS=localhost:7050
    FABRIC_CFG_PATH="../config"
    CORE_PEER_TLS_ENABLED=true
    CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/map.landrecord.com/peers/peer0.map.landrecord.com/tls/ca.crt
}

# Common location for the generated packages
CC2_PACKAGE_FOLDER=$HOME/LRBC

if [ "$#" == "0" ]; then
    usage
    echo ""
    cat cc.env.sh
    exit 0
fi

# Go through the options
L_SPECIFIED=true
reset_chaincode_variables
while getopts "G:n:p:v:l:C:c:q:i:L:S:R:P:I:s:g:e:xzh" OPTION; do

    case $OPTION in
    h)
        usage
        exit 0
        ;;
    n)
        # Used for install | instantiate | query | invoke
        export CC_NAME=${OPTARG}
        # Used for dev mode execution
        export CORE_CHAINCODE_ID_NAME=$CC_NAME
        ;;
    p)
        export CC_PATH=${OPTARG}
        echo "path $CC_PATH"
        if [ "$L_SPECIFIED" == "false" ]; then
            echo "MUST SPECIFY Language with -p !!!"
            exit 1
        fi
        if [ "$CC_LANGUAGE" == "golang" ]; then
            echo "Golang" 1>/dev/null
        elif [ "$CC_LANGUAGE" == "node" ]; then
            CC_PATH=$NODEPATH/$CC_PATH
        elif [ "$CC_LANGUAGE" == "java" ]; then
            CC_PATH=$JAVAPATH/$CC_PATH
        else
            echo "Invalid language :  $CC_LANGUAGE  !!!!"
            exit 0
        fi
        ;;
    l)
        export CC_LANGUAGE=${OPTARG}
        L_SPECIFIED=true
        ;;
    v)
        export CC_VERSION=${OPTARG}
        ;;
    C) # Channel Id
        export CC_CHANNEL_ID=${OPTARG}
        ;;
    c)
        export CC_CONSTRUCTOR=${OPTARG}
        ;;
    q)
        export CC_QUERY_ARGS=${OPTARG}
        ;;
    i)
        export CC_INVOKE_ARGS=${OPTARG}
        ;;
    L)
        # Controls chaincode Logging Level - used in Dev mode
        export CORE_CHAINCODE_LOGGING_LEVEL=${OPTARG}
        ;;
    S)
        # Controls shim Logging Level - used in Dev mode
        export CORE_CHAINCODE_LOGGING_SHIM=${OPTARG}
        ;;
    R)
        # Takes the Private Data JSON configuration
        # File MUST be available under the CC_PATH
        export CC_PRIVATE_DATA_JSON=${OPTARG}
        ;;
    P)
        # Endorsement policy
        echo "DEPRECATED in Fabric 2.x : Please use --siginature-policy option -g   --channel-config-policy option option -G"
        exit
        export CC_ENDORSEMENT_POLICY=${OPTARG}
        ;;

    # CC 2.0 properties
    s)
        # Sets up the Sequence number
        export CC2_SEQUENCE=${OPTARG}
        ;;
    I)
        # Sets up the --init-required flag
        export CC2_INIT_REQUIRED=${OPTARG}
        ;;

    g)
        # Sets up the Signature Policy
        export CC2_SIGNATURE_POLICY
        export CC2_SIGNATURE_POLICY=${OPTARG}
        ;;

    G)
        # Sets the channel config Policy
        export CC2_CHANNEL_CONFIG_POLICY
        export CC2_CHANNEL_CONFIG_POLICY=${OPTARG}
        ;;

    e) # Sets teh endorsing peer option
        ORG_NAME=${OPTARG} 
        if [ -z $ORG_NAME ]; then
            usage
            echo "Please provide the ORG Name!!!"
        elif [ "$ORG_NAME" = "map" ]; then
            echo "Setting ENV for MAP"
            export CORE_PEER_ADDRESS=localhost:7051
            export CORE_PEER_LOCALMSPID="mapMSP"
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/map.landrecord.com/users/Admin@map.landrecord.com/msp
            export CORE_PEER_ID=peer0.map.landrecord.com
        elif [ "$ORG_NAME" = "registrar" ]; then
            echo "Setting ENV for REGISTRAR"
            export CORE_PEER_ADDRESS=localhost:9051
            export CORE_PEER_LOCALMSPID="registrarMSP"
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/users/Admin@registrar.landrecord.com/msp
            export CORE_PEER_ID=peer0.registrar.landrecord.com
            export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/registrar.landrecord.com/peers/peer0.registrar.landrecord.com/tls/ca.crt
        elif [ "$ORG_NAME" = "revenue" ]; then
            echo "Setting ENV for REVENUE"
            export CORE_PEER_ADDRESS=localhost:10051
            export CORE_PEER_LOCALMSPID="revenueMSP"
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/users/Admin@revenue.landrecord.com/msp
            export CORE_PEER_ID=peer0.revenue.landrecord.com
            export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/revenue.landrecord.com/peers/peer0.revenue.landrecord.com/tls/ca.crt
        elif [ "$ORG_NAME" = "welfare" ]; then
            echo "Setting ENV for welfare"
            export CORE_PEER_ADDRESS=localhost:11051
            export CORE_PEER_LOCALMSPID="welfareMSP"
            export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/welfare.com/users/Admin@welfare.com/msp
            export CORE_PEER_ID=peer0.welfare.com
            export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/welfare.com/peers/peer0.welfare.com/tls/ca.crt
        else
            usage
            echo "INVALID ORG Name!!!"
        fi
        ;;
    z)
        # Reset the cc variables
        echo "Resetting the Chaincode Environment Variables."
        reset_chaincode_variables
        ;;
    x)
        # increment the internal - dev version
        INTERNAL_DEV_VERSION=$((INTERNAL_DEV_VERSION + 1))
        ;;
    *)
        echo "Incorrect options provided"
        exit 1
        ;;
    esac
done

if [ -z "$CC_LANGUAGE" ]; then
    CC_LANGUAGE=golang
fi

echo "# Generated: $(date)" >cc.env.sh
echo "export CC_LANGUAGE=$CC_LANGUAGE" >>cc.env.sh
echo "export CC_PATH=$CC_PATH" >>cc.env.sh
echo "export CC_NAME=$CC_NAME" >>cc.env.sh
echo "export CC_VERSION=$CC_VERSION" >>cc.env.sh
echo "export CC_CHANNEL_ID=$CC_CHANNEL_ID" >>cc.env.sh
echo "export CC_CONSTRUCTOR='$CC_CONSTRUCTOR'" >>cc.env.sh
echo "export CC_QUERY_ARGS='$CC_QUERY_ARGS'" >>cc.env.sh
echo "export CC_INVOKE_ARGS='$CC_INVOKE_ARGS'" >>cc.env.sh
echo "export CORE_CHAINCODE_ID_NAME='$CORE_CHAINCODE_ID_NAME'" >>cc.env.sh
echo "export CORE_CHAINCODE_LOGGING_LEVEL='$CORE_CHAINCODE_LOGGING_LEVEL'" >>cc.env.sh
echo "export CORE_CHAINCODE_LOGGING_SHIM='$CORE_CHAINCODE_LOGGING_SHIM'" >>cc.env.sh
echo "export CC_PRIVATE_DATA_JSON='$CC_PRIVATE_DATA_JSON'" >>cc.env.sh
echo "export CC_ENDORSEMENT_POLICY=\"$CC_ENDORSEMENT_POLICY\"" >>cc.env.sh
echo "export CC2_SEQUENCE=\"$CC2_SEQUENCE\"" >>cc.env.sh
echo "export CC2_INIT_REQUIRED=\"$CC2_INIT_REQUIRED\"" >>cc.env.sh
echo "export CC2_PACKAGE_FOLDER=\"$CC2_PACKAGE_FOLDER\"" >>cc.env.sh
echo "export CC2_SIGNATURE_POLICY=\"$CC2_SIGNATURE_POLICY\"" >>cc.env.sh
echo "export CC2_CHANNEL_CONFIG_POLICY=\"$CC2_CHANNEL_CONFIG_POLICY\"" >>cc.env.sh
echo "export CC2_ENDORSING_PEERS=\"$CC2_ENDORSING_PEERS\"" >>cc.env.sh
echo "export CC2_ENV_FOLDER=\"$CC2_ENV_FOLDER\"" >>cc.env.sh
echo "export INTERNAL_DEV_VERSION=\"$INTERNAL_DEV_VERSION\"" >>cc.env.sh
echo "export CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" >>cc.env.sh
echo "export CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" >>cc.env.sh
echo "export CORE_PEER_ID=$CORE_PEER_ID" >>cc.env.sh
echo "export FABRIC_LOGGING_SPEC=$FABRIC_LOGGING_SPEC" >>cc.env.sh
echo "export CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" >>cc.env.sh
echo "export ORDERER_ADDRESS=$ORDERER_ADDRESS" >>cc.env.sh
echo "export FABRIC_CFG_PATH=$FABRIC_CFG_PATH" >>cc.env.sh
echo "export CORE_PEER_TLS_ENABLED=$CORE_PEER_TLS_ENABLED">>cc.env.sh
echo "export CORE_PEER_TLS_ROOTCERT_FILE=$CORE_PEER_TLS_ROOTCERT_FILE">>cc.env.sh
