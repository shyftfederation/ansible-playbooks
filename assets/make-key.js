

const ethers = require('ethers');

// Randomly generate a private key
let wallet = ethers.Wallet.createRandom()
let privateKey = wallet.privateKey;

console.log(privateKey)
// Define a password
let password = "password123";


// Encrypt the private key with the password
wallet.encrypt(password).then(function(json) {
    // The json variable is a JSON-encoded keyfile
    const fs = require('fs');
    const fileName = wallet.address + '.json';
    fs.writeFile(fileName, json, function(err) {
        if(err) {
            return console.log(err);
        }
        console.log("The file " + fileName + " was saved!");
    });
});
