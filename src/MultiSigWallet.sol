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
        uint approvals;             // Number of approvers who already validates the transaction
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
        approvers = _approvers;
        quorum = _quorum;
    }

    function getApprovers() external view returns(address[] memory) {
        return approvers;
    }

    /**
     * Call this method for create a transfert from your wallet, to an another wallet
     * @param _to address of the receiver
     * @param _amount amount of ETH you want to send to the receiver
     */
    function createTransfert(address payable _to, uint _amount) external {
        Transfer memory transfert = Transfer(
            transfers.length,
            _amount,
            _to,
            0,
            false
        );
        transfers.push(transfert);
    }
}
