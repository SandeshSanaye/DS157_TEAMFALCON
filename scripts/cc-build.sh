#!/bin/bash

# Builds the chaincode

source cc.env.sh

echo "$GOPATH/src/$CC_PATH"
# Executes chaincode in dev mode

echo "====> Building the GoLang chaincode ...please wait"
#go build -o $CC_PATH
# export GOCACHE=off
go build  $CC_PATH

RESULT=$?
if [ "$RESULT" != "0" ]; then
    echo "Build Failed!!!"
    exit $RESULT
else
    echo "Build Succeeded!!"
fi

exit 0