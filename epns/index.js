// import pkg from '@epnsproject/backend-sdk-staging'
// //import { EpnsSDK } from "@epnsproject/backend-sdk-staging";
// import { ethers} from "ethers"

const EpnsSDK = require("@epnsproject/backend-sdk-staging").default;
const ethers = require('ethers');
require('dotenv').config();
console.log(process.env)

// Define the parameters we would need in order to initialize the SDK
const  CHANNEL_PK = process.env.CHANNEL_PK;


// Initialise the SDK
const  epnsSdk = new EpnsSDK(CHANNEL_PK);


const provider = new ethers.providers.JsonRpcProvider("https://rpc-mumbai.matic.today");
const signer = provider.getSigner();

// console.log(await provider.getBlockNumber());

provider.getBlockNumber().then(res => console.log(res))


const pushNotificationTitle = "Box has been stolen";
const pushNotificationBody = ""

let boxBrokenFilter = {
    address:"0x864B80657b62FE55B1650374bCBa77d814901ED1",
    topics: [
        ethers.utils.id("BoxStolen(address,address)")
    ]
}

provider.on(boxBrokenFilter, (event) =>{
    console.log('test')
    console.log(JSON.stringify(event));
    response = handleBoxStolenEvent(event);
    response.then(res => console.log(res));
})


function handleBoxStolenEvent(event) {
    const pushNotificationTitle = "Box has been stolen";
    const pushNotificationBody = event.topics[1] + ' has stolen the box from ' + event.topics[2];

    const response = epnsSdk.sendNotification(
        "0xA16b387a3ce2943018fF88a2CfA1341DE844A668",
        pushNotificationTitle,
        pushNotificationBody,
        pushNotificationTitle,
        pushNotificationBody,
        1,
        "http://degen.bar/box"

    )

    return response;

}