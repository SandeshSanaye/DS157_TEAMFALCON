package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

const processName = "Ownership"

// OwnershipChaincode required by shim
type OwnershipChaincode struct {
}

// Init function ignore the arguments
func (conversion *OwnershipChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {
	fmt.Println("Init executed")
	return shim.Success(nil)
}

// Invoke function call function based on funcName
func (conversion *OwnershipChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	funcName, args := stub.GetFunctionAndParameters()
	if funcName == "set" {
		return SetOwnership(stub, args[0])
	} else if funcName == "get" {
		return GetOwnership(stub, args[0])
	} else if funcName == "list" {
		return GetSurveyNoList(stub, args[0])
	}
	return shim.Error("Fuction name '" + funcName + "' is wrong or " + funcName + " function does not exist!!!")
}

// SetOwnership add land ownership details
func SetOwnership(stub shim.ChaincodeStubInterface, argJSON string) peer.Response {
	// Get Village UID by invoking conversion chaincode
	invokeArgs := make([][]byte, 2)
	invokeArgs[0] = []byte("get")
	invokeArgs[1] = []byte(argJSON)
	response := stub.InvokeChaincode("conversion", invokeArgs, "landrecords")
	if response.Status != shim.OK {
		return shim.Error("No record Found!!!")
	}

	villageUID := string(response.Payload)
	var isDataValid bool
	var data []byte
	var key string

	switch stateName := villageUID[0:2]; stateName {
	case "01":
		return shim.Error("Not implemnted")
	case "02":
		return shim.Error("Not implemnted")
	case "03":
		return shim.Error("Not implemnted")
	case "04":
		return shim.Error("Not implemnted")
	case "05":
		return shim.Error("Not implemnted")
	case "06":
		return shim.Error("Not implemnted")
	case "07":
		return shim.Error("Not implemnted")
	case "08":
		return shim.Error("Not implemnted")
	case "09":
		return shim.Error("Not implemnted")
	case "10":
		return shim.Error("Not implemnted")
	case "11":
		return shim.Error("Not implemnted")
	case "12":
		return shim.Error("Not implemnted")
	case "13":
		return shim.Error("Not implemnted")
	case "14":
		return shim.Error("Not implemnted")
	case "15":
		return shim.Error("Not implemnted")
	case "16":
		return shim.Error("Not implemnted")
	case "17":
		return shim.Error("Not implemnted")
	case "18":
		return shim.Error("Not implemnted")
	case "19":
		return shim.Error("Not implemnted")
	case "20":
		return shim.Error("Not implemnted")
	case "21":
		return shim.Error("Not implemnted")
	case "22":
		return shim.Error("Not implemnted")
	case "23":
		return shim.Error("Not implemnted")
	case "24":
		return shim.Error("Not implemnted")
	case "25":
		return shim.Error("Not implemnted")
	case "26":
		return shim.Error("Not implemnted")
	case "27":
		var maharashtraFormVII MaharashtraFormVII
		err := json.Unmarshal([]byte(argJSON), &maharashtraFormVII)
		if err != nil {
			return shim.Error(err.Error())
		}
		isDataValid, key = maharashtraFormVII.Verify(villageUID)
		data, err = json.Marshal(maharashtraFormVII)
		if err != nil {
			return shim.Error(err.Error())
		}
	case "28":
		return shim.Error("Not implemnted")
	case "29":
		return shim.Error("Not implemnted")
	case "30":
		return shim.Error("Not implemnted")
	case "31":
		return shim.Error("Not implemnted")
	case "32":
		return shim.Error("Not implemnted")
	case "33":
		return shim.Error("Not implemnted")
	case "34":
		return shim.Error("Not implemnted")
	case "35":
		return shim.Error("Not implemnted")
	case "36":
		return shim.Error("Not implemnted")
	}

	if isDataValid {
		if err := stub.PutState(key, data); err != nil {
			return shim.Error("")
		}
	}
	return shim.Success(nil)

}

// GetOwnership return land ownership details
func GetOwnership(stub shim.ChaincodeStubInterface, argJSON string) peer.Response {
	// Get Village UID by invoking conversion chaincode
	invokeArgs := make([][]byte, 2)
	invokeArgs[0] = []byte("get")
	invokeArgs[1] = []byte(argJSON)
	response := stub.InvokeChaincode("conversion", invokeArgs, "landrecords")
	if response.Status != shim.OK {
		return shim.Error("No record Found!!!")
	}

	villageUID := string(response.Payload)

	switch stateName := villageUID[0:2]; stateName {
	case "01":
		return shim.Error("Not implemnted")
	case "02":
		return shim.Error("Not implemnted")
	case "03":
		return shim.Error("Not implemnted")
	case "04":
		return shim.Error("Not implemnted")
	case "05":
		return shim.Error("Not implemnted")
	case "06":
		return shim.Error("Not implemnted")
	case "07":
		return shim.Error("Not implemnted")
	case "08":
		return shim.Error("Not implemnted")
	case "09":
		return shim.Error("Not implemnted")
	case "10":
		return shim.Error("Not implemnted")
	case "11":
		return shim.Error("Not implemnted")
	case "12":
		return shim.Error("Not implemnted")
	case "13":
		return shim.Error("Not implemnted")
	case "14":
		return shim.Error("Not implemnted")
	case "15":
		return shim.Error("Not implemnted")
	case "16":
		return shim.Error("Not implemnted")
	case "17":
		return shim.Error("Not implemnted")
	case "18":
		return shim.Error("Not implemnted")
	case "19":
		return shim.Error("Not implemnted")
	case "20":
		return shim.Error("Not implemnted")
	case "21":
		return shim.Error("Not implemnted")
	case "22":
		return shim.Error("Not implemnted")
	case "23":
		return shim.Error("Not implemnted")
	case "24":
		return shim.Error("Not implemnted")
	case "25":
		return shim.Error("Not implemnted")
	case "26":
		return shim.Error("Not implemnted")
	case "27":
		var maharashtraFormVII MaharashtraFormVII
		err := json.Unmarshal([]byte(argJSON), &maharashtraFormVII)
		if err != nil {
			return shim.Error(err.Error())
		}
		key := villageUID + maharashtraFormVII.SurveyNo + "/" + maharashtraFormVII.GatNo

		value, err := stub.GetState(key)
		if err != nil {
			return shim.Error(err.Error())
		}
		if value == nil {
			return shim.Error("Record not found")
		}
		return shim.Success(value)
	case "28":
		return shim.Error("Not implemnted")
	case "29":
		return shim.Error("Not implemnted")
	case "30":
		return shim.Error("Not implemnted")
	case "31":
		return shim.Error("Not implemnted")
	case "32":
		return shim.Error("Not implemnted")
	case "33":
		return shim.Error("Not implemnted")
	case "34":
		return shim.Error("Not implemnted")
	case "35":
		return shim.Error("Not implemnted")
	case "36":
		return shim.Error("Not implemnted")
	}
	return shim.Error("Record not found")
}

// GetSurveyNoList return list of Form VII present in a village
func GetSurveyNoList(stub shim.ChaincodeStubInterface, argJSON string) peer.Response {

	// Create args array
	invokeArgs := make([][]byte, 2)
	invokeArgs[0] = []byte("get")
	invokeArgs[1] = []byte(argJSON)

	// Get Village UID by invoking conversion chaincode
	response := stub.InvokeChaincode("conversion", invokeArgs, "landrecords")
	if response.Status != shim.OK {
		return shim.Error("No record Found!!!")
	}

	villageUID := string(response.Payload)

	// query for getting list of ownership document id
	quvery := `{
		"selector": {
		   "_id": {
			  "$regex": `

	quvery += villageUID

	quvery += `}
		},
		"fields": [ "_id" ]
	 }`

	// run query
	ownershipIDIterator, err := stub.GetQueryResult(quvery)

	// check for any error
	if err != nil {
		return shim.Error("!!!Error from " + processName + " Failed to run query Error: " + err.Error())
	}

	// convert iterator to byte array
	byteList, err := json.Marshal(ownershipIDIterator)

	// check for error
	if err != nil {
		return shim.Error("!!!Error from " + processName + " Failed to marshal list. Error: " + err.Error())
	}

	return shim.Success(byteList)
}

func main() {
	fmt.Println("#####  Owership chaincode stared ####")

	err := shim.Start(new(OwnershipChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}
}
