import {ethers} from "hardhat";

async function deploy() {
    try {
        const myContract = await ethers.getContractFactory("DimaToken")
        const contract = await myContract.deploy("0x94fD0181973d7304b7654C4c0AdED1b5a140Db7D")
        await contract.waitForDeployment()

        console.log(`contract address: ${await contract.getAddress()}`)
    } catch (error) {
        console.log(error)
    }
}

deploy();