import { ethers, expect, loadFixture } from "./setup";

describe("DimaTokenTest", async function() {

    async function deploy() {
        const [owner, user2] = await ethers.getSigners();

        const factory = await ethers.getContractFactory("DimaToken", owner);
        const contract = await factory.deploy(owner);
        await contract.waitForDeployment();

        return {owner, user2, contract};
    }

    it("should be an nft on owner account", async function () {
        const {owner, user2, contract} = await loadFixture(deploy);

        const tx = await contract.balanceOf(owner);

        expect(tx).to.eq(1);
    })

    it("should mint new nft", async function() {
        const { user2, contract} = await loadFixture(deploy);

        const priceForMint = 100000000000000;

        //failed transaction
        await expect(contract.connect(user2).mint(123, { value: (priceForMint - 1) })).to.revertedWithCustomError(contract, "SmallSumForMint")

        const succesMintTx = await contract.connect(user2).mint(123, { value: priceForMint })

        expect(succesMintTx).to.changeEtherBalance(user2, -priceForMint);
        expect(succesMintTx).to.changeEtherBalance(contract, priceForMint);
        expect(await contract.balanceOf(user2)).to.eq(1)
    })

    it("should witdraw from contract", async function() {
        const {owner, user2, contract} = await loadFixture(deploy);

        const priceForMint = 100000000000000;

        const succesMintTx = await contract.connect(user2).mint(123, { value: priceForMint })

        expect(succesMintTx).to.changeEtherBalance(user2, -priceForMint);
        expect(succesMintTx).to.changeEtherBalance(contract, priceForMint);

        await expect(contract.connect(user2).withdrawToOwner()).to.revertedWithCustomError(contract, "OwnableUnauthorizedAccount")

        const successWithdrawTx = await contract.connect(owner).withdrawToOwner()

        expect(successWithdrawTx).to.changeEtherBalance(contract, -priceForMint);
        expect(successWithdrawTx).to.changeEtherBalance(owner, priceForMint);
    })

    it("should change mint price", async function() {
        const {owner, user2, contract} = await loadFixture(deploy);

        const priceForMint = 100000000000000;

        const succesMintTx = await contract.connect(user2).mint(123, { value: priceForMint })

        expect(succesMintTx).to.changeEtherBalance(user2, -priceForMint);
        expect(succesMintTx).to.changeEtherBalance(contract, priceForMint);
        
        await expect(contract.connect(user2).changePriceForMint((1))).to.revertedWithCustomError(contract, "OwnableUnauthorizedAccount")

        await contract.connect(owner).changePriceForMint((priceForMint + 1))

        await expect(contract.connect(user2).mint(123, { value: priceForMint })).to.revertedWithCustomError(contract, "SmallSumForMint")
    })
})