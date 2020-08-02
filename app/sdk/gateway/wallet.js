/**
 * 
 * Wallet API to create wallet
 * 
 */

'use strict';

const FabricCAServices = require('fabric-ca-client');
const { Wallets, X509WalletMixin } = require('fabric-network');
const fs = require('fs');
const path = require('path');

// Folder for creating the wallet - All identities written under this
const WALLET_FOLDER = './wallet'

// Create an instance of the file system wallet
const wallet = Wallets.newFileSystemWallet(WALLET_FOLDER);

// Get the requested actionts
let action='list'
if (process.argv.length > 2){
    action = process.argv[2]
}

// Check on the action requested
if(action == 'list'){
    console.log("List of identities in wallet:")
    listIdentities()
} else if (action == 'add' || action == 'export'){
    if(process.argv.length < 5){
        console.log("For 'add' & 'export' - Org & User are needed!!!")
        process.exit(1)
    }
    if (action == 'add'){
        addToWallet(process.argv[3], process.argv[4])
        console.log('Done adding/updating.')
    } else {
        exportIdentity(process.argv[3], process.argv[4])
    }
} 

/**
 * @param   string  Organization = map revenue registrar welfare
 * @param   string  User  = Admin   User   that need to be added
 */
async function addToWallet(org, user) {
    try {
        // load the network configuration
        let domain = '.landrecord.com'
        if (org == "welfare"){
            domain = ".com"
        }
        const ccpPath = path.resolve(__dirname, '../../../organizations/peerOrganizations/' + org + domain +'/connection-'+org+'.json');
        console.log(ccpPath)
        let ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new CA client for interacting with the CA.
        const caURL = ccp.certificateAuthorities['ca.'+org+domain].url;
        const ca = new FabricCAServices(caURL);

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the admin user.
        const adminExists = await wallet.get(org);
        if (adminExists) {
            console.log('An identity for the admin user "admin" already exists in the wallet');
            return;
        }

        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret:'adminpw' });
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: org + 'MSP',
            type: 'X.509',
        };
        await wallet.put(user, x509Identity);
        console.log('Successfully enrolled '+user+' and imported it into the wallet');

    } catch (error) {
        console.error(`Failed to enroll user ${user}: ${error}`);
        process.exit(1);
    }
}

/**
 * Lists/Prints the identities in the wallet
 */
async function listIdentities(){
    console.log("Identities in Wallet:")

    // Retrieve the identities in folder
    let list = await wallet.list()
 
    // Loop through the list & print label
    for(var i=0; i < list.length; i++) {
         console.log((i+1)+'. '+list[i].label)
    }
 
 }

 /**
 * Extracts the identity from the wallet
 * @param {string} org 
 * @param {string} user 
 */
async function exportIdentity(org, user) {
    // Label is used for identifying the identity in wallet
    let label = createIdentityLabel(org, user)

    // To retrive execute export
    let identity = await wallet.export(label)

    if (identity == null){
        console.log(`Identity ${user} for ${org} Org Not found!!!`)
    } else {
        // Prints all attributes : label, Key, Cert
        console.log(identity)
    }
}
