package main

import (
	"strings"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

// Generate uid
func Generate(stub shim.ChaincodeStubInterface, start int, end int) peer.Response {

	result := strings.Split(data, ",")
	for i := start; i < end; i += 2 {
		stub.PutState(result[i], []byte(result[i+1]))
	}
	return shim.Success(nil)
}