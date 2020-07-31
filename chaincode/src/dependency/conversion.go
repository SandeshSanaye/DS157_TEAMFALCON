package dependency

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

// ConversionChaincode contain nothing
type ConversionChaincode struct {
	State       string `json:"state"`
	District    string `json:"district"`
	SubDistrict string `json:"subdistrict"`
	Village     string `json:"village"`
}

const processName = "Conversion Dependency"

// Init do nothing
func (conversion *ConversionChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {
	fmt.Println("Init executed")

	return shim.Success(nil)
}

// Invoke call fuctions and return peer.Response
func (conversion *ConversionChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	funcName, args := stub.GetFunctionAndParameters()
	if funcName == "state" {
		return SetState(stub)
	} else if funcName == "district" {
		return SetDistrict(stub)
	} else if funcName == "subdistrict" {
		return SetSubDistrict(stub)
	} else if funcName == "village" {
		return SetVillage(stub)
	} else if funcName == "get" {
		return GetUID(stub, args[0])
	}
	return shim.Error("Fuction name '" + funcName + "' is wrong or " + funcName + " function does not exist!!!")
}

// SetState set state code
func SetState(stub shim.ChaincodeStubInterface) peer.Response {
	args := stub.GetStringArgs()

	if len(args) != 3 {
		return shim.Error("Incorrect arguments. Expecting two arguments 'name of state' & 'state code'")
	}

	_, err := strconv.Atoi(args[2])
	if err != nil {
		return shim.Error("Incorrect data type state code should be a number!!!")
	}

	key := strings.ToLower(args[1])
	stub.PutState(key, []byte(args[2]))

	return shim.Success([]byte("true"))
}

// SetDistrict set district code
func SetDistrict(stub shim.ChaincodeStubInterface) peer.Response {
	var buffer bytes.Buffer
	var value []byte
	args := stub.GetStringArgs()
	if len(args) != 4 {
		return shim.Error("Incorrect arguments. Expecting three arguments 'name of state' 'name of district' & 'district code'")
	}

	_, err := strconv.Atoi(args[3])
	if err != nil {
		return shim.Error("Incorrect data type district code should be a number!!!")
	}

	keys := args[1:2]
	buffer.WriteString("")
	for _, key := range keys {
		key := strings.ToLower(buffer.String() + key)
		if value, err = stub.GetState(key); err != nil {
			fmt.Println("Get failed!!! ", err.Error())
			return shim.Error(("Get failed!! " + err.Error() + " !!!"))
		}
		if value == nil {
			return shim.Error(key + " not found in record!!!")
		}
		buffer.WriteString(string(value))
	}

	key := buffer.String() + strings.ToLower(args[2])
	stub.PutState(key, []byte(args[3]))

	return shim.Success([]byte("true"))
}

// SetSubDistrict set sub-District code
func SetSubDistrict(stub shim.ChaincodeStubInterface) peer.Response {
	var buffer bytes.Buffer
	var value []byte
	args := stub.GetStringArgs()
	if len(args) != 5 {
		return shim.Error("Incorrect arguments. Expecting four 'name of state' 'name of district' 'name of sub-district' & 'sub-district code'")
	}

	_, err := strconv.Atoi(args[4])
	if err != nil {
		return shim.Error("Incorrect data type sub-district code should be a number!!!")
	}

	keys := args[1:3]
	buffer.WriteString("")
	for _, key := range keys {
		key := strings.ToLower(buffer.String() + key)
		if value, err = stub.GetState(key); err != nil {
			fmt.Println("Get failed!!! ", err.Error())
			return shim.Error("Get failed!! " + err.Error() + " !!!")
		}
		if value == nil {
			return shim.Error(key + " not found in record!!!")
		}
		buffer.WriteString(string(value))

	}

	key := buffer.String() + strings.ToLower(args[3])
	stub.PutState(key, []byte(args[4]))

	return shim.Success([]byte("true"))
}

// SetVillage set village code
func SetVillage(stub shim.ChaincodeStubInterface) peer.Response {
	var buffer bytes.Buffer
	var value []byte
	args := stub.GetStringArgs()
	if len(args) != 6 {
		return shim.Error("Incorrect arguments. Expecting five arguments 'name of state' 'name of district' 'name of sub-district' 'name of village' & 'village code'")
	}

	_, err := strconv.Atoi(args[5])
	if err != nil {
		return shim.Error("Incorrect data type village code should be a number!!!")
	}

	keys := args[1:4]
	buffer.WriteString("")
	for _, key := range keys {
		key := strings.ToLower(buffer.String() + key)
		if value, err = stub.GetState(key); err != nil {
			fmt.Println("Get failed!!! ", err.Error())
			return shim.Error("Get failed!! " + err.Error() + " !!!")
		}
		if value == nil {
			return shim.Error(key + " not found in record!!!")
		}
		buffer.WriteString(string(value))
	}

	key := buffer.String() + strings.ToLower(args[4])
	stub.PutState(key, []byte(args[5]))

	return shim.Success([]byte("true"))
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
