package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"reflect"
	"strconv"
	"strings"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

// ConversionChaincode contain state, district, sub-district, village
type ConversionChaincode struct {
	State       string `json:"state"`
	District    string `json:"district"`
	SubDistrict string `json:"subdistrict"`
	Village     string `json:"village"`
}

// Used in erro message to find where error get from
const processName = "Internal Conversion"

// Init do nothing
func (conversion *ConversionChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

// Invoke call fuctions and return peer.Response
func (conversion *ConversionChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	funcName, args := stub.GetFunctionAndParameters()

	if len(args) != 1 {
		return shim.Error("!!!Error from " + processName + " Incorrect arguments. Expecting one parameter but recevied " + strconv.Itoa(len(args)))
	}

	funcName = strings.ToLower(funcName)

	// Call function
	if funcName == "get" {
		return GetUID(stub, args[0])
	} else if funcName == "generate" {
		value, err := stub.GetState("generate")
		if err != nil {
			return shim.Error("!!!Error from" + processName + "Unable to get data Error: " + err.Error())
		}
		if value == nil {
			Generate(stub, 0, 44334)
			stub.PutState("generate", []byte("one"))
			return shim.Success(nil)
		} else if string(value) == "one" {
			Generate(stub, 44334, 88668)
			stub.PutState("generate", []byte("done"))
			return shim.Success(nil)
		}
		return shim.Error("!!!Error from" + processName + " Already data added.")
	}
	return shim.Error("!!!Error from " + processName + " Undefined function " + funcName)
}

// GetUID return unique code of village in India
func GetUID(stub shim.ChaincodeStubInterface, jsonArgs string) peer.Response {

	var conversionChaincode ConversionChaincode
	err := json.Unmarshal([]byte(jsonArgs), &conversionChaincode)
	if err != nil {
		return shim.Error("!!!Error from " + processName + " Unable to marshal parameter. Marshal Error: " + err.Error())
	}

	args := reflect.ValueOf(conversionChaincode)
	var key bytes.Buffer
	key.WriteString("")

	for i := 0; i < args.NumField(); i++ {
		value, err := stub.GetState(key.String() + strings.ToLower(args.Field(i).Interface().(string)))
		if err != nil {
			return shim.Error("!!!Error from " + processName + " error occured while get data!!! Error:" + err.Error())
		}
		if value == nil {
			return shim.Error("!!!Error from " + processName + " Requested " + args.Type().Field(i).Name + ": " + args.Field(i).Interface().(string) + " not found in record.")
		}
		key.WriteString(string(value))
	}

	return shim.Success([]byte(key.String()))
}

func main() {
	fmt.Println("####  Conversion Chaincode Started  ####")

	err := shim.Start(new(ConversionChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}
}
