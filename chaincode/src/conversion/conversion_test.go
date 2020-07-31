package main

import (
	"strings"
	"testing"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/shimtest"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

func TestInstancesCreation(test *testing.T) {
	stub := InitChaincode(test)
	Invoke(test, stub, "generate", "a")
	Invoke(test, stub, "generate","a")
	Invoke(test, stub, "get", `{"State" : "Maharashtra","District" : "Nandurbar", "Subdistrict" :"Akkalkuwa", "Village" : "Manibeli"}`)
}

func InitChaincode(test *testing.T) *shimtest.MockStub {
	stub := shimtest.NewMockStub("testingStub", new(ConversionChaincode))
	result := stub.MockInit("000", nil)
	if result.Status != shim.OK {
		test.FailNow()
	}
	return stub
}

func Invoke(test *testing.T, stub *shimtest.MockStub, function string, args ...string) {
	ccArgs := make([][]byte, 1+len(args))
	ccArgs[0] = []byte(function)
	for i, arg := range args {
		ccArgs[i+1] = []byte(arg)
	}
	response := stub.MockInvoke("000", ccArgs)
	if response.Status != shim.OK {
		test.Fatal(response.Message)
	}
	dumpResponse(test, ccArgs, response)
}

func dumpResponse(test *testing.T, args [][]byte, response peer.Response) {

	// Holds arg strings
	argsArray := make([]string, len(args))
	for i, arg := range args {
		argsArray[i] = string(arg)
	}

	test.Log("Call:    ", strings.Join(argsArray, ","))
	test.Log("RetCode: ", response.Status)
	test.Log("RetMsg:  ", response.Message)
	test.Log("Payload: ", string(response.Payload))
}
