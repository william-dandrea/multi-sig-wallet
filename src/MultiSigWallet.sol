pragma solidity >=0.7.0 <0.9.0;

contract MultiSigWallet {

    /**
     * Adresses of the person who will have to approve one transaction
     */
    address[] public approvers;

    /**
     * Number of minimal approver who have to valid one transaction
     */
    uint public quorum;

    struct Transfer {
        uint id;                    // id of the transfert (should be unique)
        uint amount;                // ETH amount of the transaction
        address payable to;         // Destination adress of the transfert
        address[] validators;       // List of approvers who already validates the transaction
        bool is_already_sent;       // Is the transaction already send ?
    }

    /**
     * List of all the transfers made in the smart-contract
     */
    Transfer[] public transfers;

    /**
     * @param _approvers Adresses of the person who will have to approove one transaction
     * @param _quorum Number of minimal approver who have to valid one transaction
     */
    constructor(address[] memory _approvers, uint _quorum) {
        require(_approvers.length > _quorum, "Number of addresses have to be greater than quorum");
        approvers = _approvers;
        quorum = _quorum;
    }

    /**
     * Send ether to the smart contract (just need to provide the adress)
     */
    receive() external payable {}

    function getApprovers() external view returns(address[] memory) {
        return approvers;
    }

    function getTransfers() external view returns(Transfer[] memory) {
        return transfers;
    }

    /**
     * Call this method for create a transfert from your wallet, to an another wallet
     * @param _to address of the receiver
     * @param _amount amount of ETH you want to send to the receiver
     */
    function createTransfert(address payable _to, uint _amount) external isApprover() {

        Transfer memory newTransfer = Transfer(
            transfers.length,
            _amount,
            _to,
            new address[](0),
            false
        );
        transfers.push(newTransfer);
    }

    /**
     * A approver can call this method for approoving a specific transfert
     * @param _transfertId id of the transation in transfers array
     */
    function approveTransfert(uint _transfertId) external isApprover() {
        address sender = msg.sender;

        require(_transfertId >= 0 && _transfertId < transfers.length, "This transaction doesn't exist");
        require(transfers[_transfertId].is_already_sent == false, "Transfer already done");

        transfers[_transfertId].validators.push(sender);

        if (transfers[_transfertId].validators.length >= quorum) {
            // We can approove transaction
            transfers[_transfertId].is_already_sent = true;

            address payable to = transfers[_transfertId].to;
            to.transfer(transfers[_transfertId].amount);
        }
    }

    /**
     * Check if sender is an approover or not
     */
    modifier isApprover() {
        bool allowed = false;
        for (uint i = 0; i < approvers.length; i++) {
            if (approvers[i] == msg.sender) {
                allowed = true;
                break;
            }
        }
        require(allowed == true, "Access denied");
        _;
    }
}
