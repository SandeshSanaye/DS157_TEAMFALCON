'use strict';

const { Wallets, Gateway } = require('fabric-network');
const fs = require('fs');
const yaml = require('js-yaml')
const gateway = new Gateway();
        
invoke();
async function invoke() {
    try {
        // Folder for creating the wallet - All identities written under this
        const WALLET_FOLDER = './wallet'

        // Create an instance of the file system wallet
        const wallet = await Wallets.newFileSystemWallet(WALLET_FOLDER);
        
        const connectionProfile = yaml.safeLoad(fs.readFileSync('../profile/connection.yaml'));

        await gateway.connect(connectionProfile, {
            identity: 'reader',
            wallet
        });
        // Obtain the smart contract with which our application wants to interact
        const network = await gateway.getNetwork('landrecords');
        const contract = network.getContract('conversion');

        // Submit transactions for the smart contract
        const args = [`{"State" : "Maharashtra","District" : "Nandurbar", "Subdistrict" :"Akkalkuwa", "Village" : "Manibeli"}`];
        // const submitResult = await contract.submitTransaction('conversion', ...args);

        // Evaluate queries for the smart contract
        const evalResult = await contract.evaluateTransaction('get', ...args);
        console.log(`Qurey Responses=${evalResult.toString()}`)
    } catch (error) {
        console.error(`Failed invoke query : ${error}`);
        process.exit(1);
    }
    finally {
        // Disconnect from the gateway peer when all work for this client identity is complete
        gateway.disconnect();
    }
} 