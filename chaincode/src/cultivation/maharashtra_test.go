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
	stub := InitChaincode(test, "form12")
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
		"surveyNO": "12",
		"gatNo": "1",
		"year": 0,
		"season": "",
		"DetailsOfCroppedArea": {
			"MixedCropsArea": {
				"mixureCode": "",
				"irraigated": "",
				"unirrigated": "",
				"ConstituentCrops": {
					"cropName": "",
					"irraigated": "",
					"unirrigated": ""
				}
			},
			"PureCropArea": {
				"pureCropName": "",
				"irraigated": "",
				"unirrigated": ""
			}
		},
		"UncultivableLand": {
			"nature": "",
			"area": ""
		},
		"irrigationSource": "",
		"remark": ""
	}`)
	Invoke(test, stub, "get", `{"State" : "Maharashtra","District" : "Nandurbar", "Subdistrict" :"Akkalkuwa", "Village" : "Manibeli", "SurveyNo" : "12", "GatNo" : "1"}`)
}

func InitChaincode(test *testing.T, chaincodeName string) *shimtest.MockStub {
	stub := shimtest.NewMockStub(chaincodeName, new(CultivationChaincode))
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
