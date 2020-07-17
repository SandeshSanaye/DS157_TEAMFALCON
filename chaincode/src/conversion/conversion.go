package main

import (
	"fmt"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

type TestChaincode struct {
	
}

func (test *TestChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response{
	fmt.Println("Init executed")

	return shim.Success(nil)
}

func (test *TestChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response{
	fmt.Println("Invoke executed")

	return shim.Success(nil)
}

func main() {
	fmt.Println("Started Chaincode")

	err := shim.Start(new(TestChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}	
}