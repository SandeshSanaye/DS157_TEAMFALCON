package main

import (
	"fmt"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
	"strconv"
	"strings"
	"bytes"
)

type ConversionChaincode struct {
	
}

func (conversion *ConversionChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response{
	fmt.Println("Init executed")

	return shim.Success(nil)
}

func (conversion *ConversionChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response{
	fmt.Println("##### Invoke #####")
	funcName, _ := stub.GetFunctionAndParameters()
	if(funcName == "state"){
		return SetState(stub)
	}else if(funcName == "district"){
		return SetDistrict(stub)
	}else if(funcName == "subdistrict"){
		return SetSubDistrict(stub)
	}else if(funcName == "village"){
		return SetVillage(stub)
	}else if(funcName == "get"){
		return GetUid(stub)
	}
	return shim.Error("Fuction name '"+funcName+"' is wrong or "+funcName+" function does not exist!!!")
}

func SetState(stub shim.ChaincodeStubInterface) peer.Response{
	args := stub.GetStringArgs()
	
	if(len(args) != 2 ){
		return shim.Error("Incorrect arguments. Expecting two arguments 'name of state' & 'state code'")
	}

	_, err := strconv.Atoi(args[1])
	if(err !=nil){
		return shim.Error("Incorrect data type state code should be a number!!!")
	}
	
	key := strings.ToLower(args[0])
	stub.PutState(key,[]byte(args[1]))

	return shim.Success([]byte("true"))
}

func SetDistrict(stub shim.ChaincodeStubInterface) peer.Response{
	var buffer bytes.Buffer
	var value []byte
	args := stub.GetStringArgs()
	if(len(args) != 3 ){
		return shim.Error("Incorrect arguments. Expecting three arguments 'name of state' 'name of district' & 'district code'")
	}

	_, err := strconv.Atoi(args[2])
	if(err !=nil){
		return shim.Error("Incorrect data type district code should be a number!!!")
	}

	keys := args[0:1]
	buffer.WriteString("")
	for _, key := range keys{
		key := buffer.String() + key
		if value, err = stub.GetState(key); err != nil {
			fmt.Println("Get failed!!! ", err.Error())
			return shim.Error(("Get failed!! "+ err.Error() + " !!!"))
		}
		if (value == nil){
			return shim.Error(key + "not found in record!!!")
		} else {
			buffer.WriteString(string(value))
		}
	}

	key := buffer.String() + strings.ToLower(args[1])
	stub.PutState(key,[]byte(args[2]))

	return shim.Success([]byte("true"))
}

func SetSubDistrict(stub shim.ChaincodeStubInterface) peer.Response{
	var buffer bytes.Buffer
	var value []byte
	args := stub.GetStringArgs()
	if(len(args) != 4 ){
		return shim.Error("Incorrect arguments. Expecting four 'name of state' 'name of district' 'name of sub-district' & 'sub-district code'")
	}

	_, err := strconv.Atoi(args[3])
	if(err !=nil){
		return shim.Error("Incorrect data type sub-district code should be a number!!!")
	}

	keys := args[0:2]
	buffer.WriteString("")
	for _, key := range keys{
		key := buffer.String() + key
		if value, err = stub.GetState(key); err != nil {
			fmt.Println("Get failed!!! ", err.Error())
			return shim.Error("Get failed!! "+ err.Error() + " !!!")
		}
		if (value == nil){
			return shim.Error(key + "not found in record!!!")
		} else {
			buffer.WriteString(string(value))
		}
	}

	key := buffer.String() + strings.ToLower(args[2])
	stub.PutState(key,[]byte(args[3]))

	return shim.Success([]byte("true"))
}

func SetVillage(stub shim.ChaincodeStubInterface) peer.Response{
	var buffer bytes.Buffer
	var value []byte
	args := stub.GetStringArgs()
	if(len(args) != 5 ){
		return shim.Error("Incorrect arguments. Expecting five arguments 'name of state' 'name of district' 'name of sub-district' 'name of village' & 'village code'")
	}

	_, err := strconv.Atoi(args[4])
	if(err !=nil){
		return shim.Error("Incorrect data type village code should be a number!!!")
	}

	keys := args[0:3]
	buffer.WriteString("")
	for _, key := range keys{
		key := buffer.String() + key
		if value, err = stub.GetState(key); err != nil {
			fmt.Println("Get failed!!! ", err.Error())
			return shim.Error("Get failed!! "+ err.Error() + " !!!")
		}
		if (value == nil){
			return shim.Error(key + "not found in record!!!")
		} else {
			buffer.WriteString(string(value))
		}
	}

	key := buffer.String() + strings.ToLower(args[3])
	stub.PutState(key,[]byte(args[4]))

	return shim.Success([]byte("true"))
}


func GetUid(stub shim.ChaincodeStubInterface) peer.Response{
	var value []byte
	var err error
	var buffer bytes.Buffer
	key := ""
	args := stub.GetStringArgs()
	if(len(args) != 5 ){
		return shim.Error("Incorrect arguments. Expecting five arguments 'name of state' 'name of district' 'name of sub-district' 'name of village' & 'survey id'")
	}
	for _, arg := range args{
		key += strings.ToLower(arg)
		if value, err = stub.GetState(key); err != nil {
			fmt.Println("Get failed!!! ", err.Error())
			return shim.Error("Get failed!! "+ err.Error() + " !!!")
		}
		if (value == nil){
			return shim.Error(arg + "not found in record!!!")
		} else {
			buffer.WriteString(string(value))
		}
	}

	return shim.Success([]byte(buffer.String()))
}

func main() {
	fmt.Println("Started Chaincode")

	err := shim.Start(new(ConversionChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}	
}