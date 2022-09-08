// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

abstract contract ReentrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}

abstract contract callDiam {
    function getAdmin() public view virtual returns (address);

    function getDonor(uint256 _id) public view virtual;

    function changeAdmin(address newAdmin) public virtual;

    function getDonorByID(uint256 _id) public view virtual returns (uint256);
}

contract Payments {
    callDiam Diam;

    constructor(address _diam) {
        admin = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor

        Diam = callDiam(_diam);
    }

    address private admin;

    uint internal _donor;

    mapping(uint => Donor) private donors;

    uint256[] donorsArray;

    struct Donor {
        uint256 idNumber;
        bool isActive; // if true, that person already voted
        string invoice_id;
        string state;
        string provider;
        string charges;
        string net_amount;
        string currency;
        string value;
        string account;
        string api_ref;
        string clearing_status;
        string mpesa_reference;
        string host;
        string failed_reason;
        string failed_code;
        string failed_code_link;
        string created_at;
        string updated_at;
        string challenge;
    }

    modifier isAdmin() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == admin, "Caller is not admin");

        _;
    }

    event AdminChange(address indexed oldAdmin, address indexed newAdmin);
    event AddedDonor(Donor created);

    function someAction() public view returns (address) {
        return Diam.getAdmin();
    }

    function someAction2(address newadmin) public {
        return Diam.changeAdmin(newadmin);
    }

    function getDonor(uint256 _id) public view isAdmin returns (Donor memory) {
        return donors[_id];
    }

    function donorReciept(uint256 _id) public isAdmin {
        require(_id == Diam.getDonorByID(_id), "donor not found");
        Donor storage donorData = donors[_donor];

        donorData.idNumber = _id;

        donorData.isActive = true;
        donorsArray.push(_donor);
        emit AddedDonor(donorData);
        _donor++;
    }
}
