package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

const processName = "Cultivation Chaincode"

// CultivationChaincode required by shim
type CultivationChaincode struct {
}

// Init function ignore the arguments
func (conversion *CultivationChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {
	fmt.Println("Init executed")
	return shim.Success(nil)
}

// Invoke function call function based on funcName
func (conversion *CultivationChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	funcName, args := stub.GetFunctionAndParameters()
	if funcName == "set" {
		return SetCultivationData(stub, args[0])
	} else if funcName == "get" {
		return GetCultivationData(stub, args[0])
	}
	return shim.Error("Fuction name '" + funcName + "' is wrong or " + funcName + " function does not exist!!!")
}

func main() {
	fmt.Println("#####  Owership chaincode stared ####")

	err := shim.Start(new(CultivationChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}
}

// SetCultivationData add cultivation data
func SetCultivationData(stub shim.ChaincodeStubInterface, argJSON string) peer.Response {
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
		// Convert JSON Data to MaharashtraFormXII
		var maharashtraFormXII MaharashtraFormXII
		err := json.Unmarshal([]byte(argJSON), &maharashtraFormXII)

		// check for err
		if err != nil {
			return shim.Error(err.Error())
		}
		// Verify Data
		isDataValid, key = maharashtraFormXII.Verify(villageUID)

		// Check if data exist or not
		value, err := stub.GetState(key)

		if err != nil {
			return shim.Error("!!!Error from " + processName + " failed to fetch data. Error: " + err.Error())
		}

		// check data trying add is for new year
		if value != nil {
			// convert []byte to MaharastraFormXII
			var currentData MaharashtraFormXII
			err := json.Unmarshal(value, &currentData)

			if err != nil {
				return shim.Error(err.Error())
			}

			if currentData.Year >= maharashtraFormXII.Year {
				return shim.Error("!!!Error from " + processName + " Data already exist.")
			}
		}
		// Convert MaharashtraFormXII to []byte
		data, err = json.Marshal(maharashtraFormXII)

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
	} else {
		return shim.Error("!!!Error from " + processName + " Location Data Not Found")
	}
	return shim.Success(nil)
}

// GetCultivationData get cultivation data
func GetCultivationData(stub shim.ChaincodeStubInterface, argJSON string) peer.Response {
	// Get Village UID by invoking conversion chaincode
	invokeArgs := make([][]byte, 2)
	invokeArgs[0] = []byte("get")
	invokeArgs[1] = []byte(argJSON)
	response := stub.InvokeChaincode("conversion", invokeArgs, "landrecords")
	if response.Status != shim.OK {
		return shim.Error("Error from " + processName + " No record Found")
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
		var maharashtraFormXII MaharashtraFormXII
		err := json.Unmarshal([]byte(argJSON), &maharashtraFormXII)
		if err != nil {
			return shim.Error(err.Error())
		}
		key := villageUID + maharashtraFormXII.SurveyNo + maharashtraFormXII.GatNo

		value, err := stub.GetState(key)
		if err != nil {
			return shim.Error(err.Error())
		}
		if value == nil {
			return shim.Error("!!!Error from " + processName + " Record not found.")
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
