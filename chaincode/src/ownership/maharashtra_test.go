package main

import (
	"dependency"
	"fmt"
	"strings"
	"testing"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/shimtest"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

func TestInstancesCreation(test *testing.T) {
	stub := InitChaincode(test, "form7")
	stub2 := InitChaincode1(test, "conversion")
	stub.MockPeerChaincode("conversion", stub2, "landrecords")

	Invoke(test, stub2, "state", "Maharashtra", "27")
	Invoke(test, stub2, "district", "Maharashtra", "Nandurbar", "497")
	Invoke(test, stub2, "subdistrict", "Maharashtra", "Nandurbar", "Akkalkuwa", "3950")
	Invoke(test, stub2, "village", "Maharashtra", "Nandurbar", "Akkalkuwa", "Manibeli", "525002")
	Invoke(test, stub2, "get", `{"State" : "Maharashtra","District" : "Nandurbar", "Subdistrict" :"Akkalkuwa", "Village" : "Manibeli"}`)
	Invoke(test, stub, "set", `{
		"State": "Maharashtra",
		"District": "Nandurbar",
		"Subdistrict": "Akkalkuwa",
		"Village": "Manibeli",
		"surveyNo": "12",
		"gatNo": "1",
		"tenure": "",
		"accountNumber": ["123"],
		"localName": "",
		"tenantName": "",
		"OccupantDetails": [{
			"OccupantName": "OccupantName"
		}],
		"CultivableArea": {
			"dryCrop": "",
			"garden": "",
			"rice": "",
			"varkas": "",
			"other": ""
		},
		"UncultivableLand": {
			"uncultivableLandClassA": "",
			"uncultivableLandClassB": ""
		},
		"assessment": "",
		"specialAssessment": "",
		"rent": "",
		"otherRight": "",
		"other": "",
		"piece": "",
		"oldMutationNumber": ["123"],
		"borderOrSymbol": ""
	}`)
	Invoke(test, stub, "get", `{"State" : "Maharashtra","District" : "Nandurbar", "Subdistrict" :"Akkalkuwa", "Village" : "Manibeli", "SurveyNo":"12", "GatNo":"1"}`)
	// Invoke(test, stub, "list", `{"State" : "Maharashtra","District" : "Nandurbar", "Subdistrict" :"Akkalkuwa", "Village" : "Manibeli"}`)
}

func InitChaincode(test *testing.T, chaincodeName string) *shimtest.MockStub {
	stub := shimtest.NewMockStub(chaincodeName, new(OwnershipChaincode))
	response := stub.MockInit("000", nil)

	if response.Status != shim.OK {
		test.FailNow()
	}
	return stub
}

func InitChaincode1(test *testing.T, chaincodeName string) *shimtest.MockStub {
	stub := shimtest.NewMockStub(chaincodeName, new(dependency.ConversionChaincode))
	response := stub.MockInit("000", nil)

	if response.Status != shim.OK {
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
	dumpResponse(ccArgs, response)
}

func InvokeChaincode(test *testing.T, stub *shimtest.MockStub, chaincodeName string, channelName string, function string, args ...string) {
	ccArgs := make([][]byte, 1+len(args))
	ccArgs[0] = []byte(function)
	for i, arg := range args {
		ccArgs[i+1] = []byte(arg)
	}
	fmt.Println(function)
	response := stub.InvokeChaincode(chaincodeName, ccArgs, channelName)
	if response.Status != shim.OK {
		test.Fatal(response.Message)
	}
	dumpResponse(ccArgs, response)
}

func dumpResponse(args [][]byte, response peer.Response) {
	// Holds arg strings
	argsArray := make([]string, len(args))
	for i, arg := range args {
		argsArray[i] = string(arg)
	}
	fmt.Println("Call:    ", strings.Join(argsArray, ","))
	fmt.Println("RetCode: ", response.Status)
	fmt.Println("RetMsg:  ", response.Message)
	fmt.Println("Payload: ", string(response.Payload))
}
