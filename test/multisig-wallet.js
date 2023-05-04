

const MultisigWallet = artifacts.require('MultiSigWallet');


contract("MutliSigWallet", (accounts) => {
    let mutlisigWallet;

    beforeEach(async () => {
       mutlisigWallet = await MultisigWallet.new([accounts[0], accounts[1], accounts[2]], 2);
       await web3.eth.sendTransaction({from: accounts[0], to: mutlisigWallet.address, value: 1000});
    });

    it("Should be correctly initialized", async () => {
        const approovers = await mutlisigWallet.getApprovers();
        const quorum = await mutlisigWallet.quorum();

        assert(approovers.length === 3);
        assert(approovers[0] === accounts[0]);
        assert(approovers[1] === accounts[1]);
        assert(approovers[2] === accounts[2]);
        assert(quorum.toString() === '2')
    });
});
