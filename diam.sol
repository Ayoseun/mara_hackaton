// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;







abstract contract ReentrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}





contract Diam is ReentrancyGuard{





    
    address private admin;


    uint internal  _ranger;

    uint internal _donor;

    
    




    mapping(uint => Ranger) private rangers;

    mapping(uint => Donor) private donors;

    uint256 [] rangersArray;

    uint256[] donorsArray;






    struct Ranger {
        uint256 idNumber;
        uint256 dateOfBirth; // weight is accumulated by delegation
        string lastName;
        string userAddress; // weight is accumulated by delegation
        string gender; // weight is accumulated by delegation
        string  firstName;
        string middleName;
        uint256 accountNumber; // weight is accumulated by delegation
        bool isActive;  // if true, that person already voted
        uint256 phone;   // index of the voted proposal
    }


    struct Donor{
        uint256 id;
        string password;

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
    event AddedRanger(Ranger  created);
    event AddedDonor(Donor  created);





    constructor() {
       
        admin = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit AdminChange(address(0), admin);
    }




    function changeAdmin(address newAdmin) public isAdmin {
        emit AdminChange(admin, newAdmin);
        admin = newAdmin;
    }


    function getAdmin() public  view  returns(address){
        return admin;
    }



     function addDonor(uint256 _name,string memory _password) public{
        require(
            msg.sender == admin,
            "Only Admin can add a donor."
        );
        
        Donor storage donorData = donors[_donor];
        donorData.id = _name;
        donorData.password = _password;
        donorsArray.push(_donor);
         emit AddedDonor(donorData);  
        _donor++;
    }



   
        function addUser(string memory _userAdd,string memory _gender,uint256 _dob,uint _phone,string memory _firstName,string memory  _lastName,uint256  _account) public{
        require(
            msg.sender == admin,
            "Only chairperson can give right to vote."
        );
        
        require(
            !rangers[_ranger].isActive,
            "This user is deactivatyed by admin"
        );

        Ranger storage userData = rangers[_ranger];
        

        userData.dateOfBirth = _dob;
        userData.userAddress=_userAdd;
        userData.phone = _phone;
        userData.gender = _gender;
        userData.firstName = _firstName;
        userData.lastName = _lastName;
        userData.accountNumber = _account;
        userData.isActive = true;
        rangersArray.push(_ranger);
         emit AddedRanger(userData);  
        _ranger++;
    }



      //get all users by id number returns integer and string
     //it is set to admin only
    function getRanger(uint256 _id) public isAdmin view returns (Ranger memory) {
                 Ranger memory rangerData;
      for (uint i = 0; i < _ranger; i++) {
          Ranger storage ranger = rangers[i];
         rangerData =ranger;
          if (rangerData.idNumber==_id) {
             return rangerData;
          }
      }
 return rangerData;
    }
       


    function getDonor(uint256  _id) public isAdmin view returns (Donor memory) {

         Donor memory donorData;
      for (uint i = 0; i < _donor; i++) {
          Donor storage donor = donors[i];
         donorData =donor;
          if (donorData.id==_id) {
             return donorData;
          }
      }
 return donorData;
    }



        function getDonorByID(uint256  _id) public view returns (uint256) {

         Donor memory donorData;
      for (uint i = 0; i < _donor; i++) {
          Donor storage donor = donors[i];
         donorData =donor;
          if (donorData.id==_id) {
             return donorData.id;
          }
      }
 return donorData.id;
    }



      function getAllUsers() public view returns (Ranger[] memory){
      Ranger[]    memory id =new Ranger[](_ranger);
      for (uint i = 0; i < _ranger; i++) {
          Ranger storage ranger = rangers[i];
          id[i] = ranger;
      }
      return id;
  }

      function getAllDonors() public view returns (Donor[] memory){
      Donor[]    memory id = new Donor[](_donor);
      for (uint i = 0; i < _donor; i++) {
          Donor storage donor = donors[i];
          id[i] = donor;
      }
      return id;
  }


    // //Pushed a piece of data to a user
    // function addData(uint256 _acctNum, string memory _data) public {

    //      require(
    //         msg.sender == admin,
    //         "Only chairperson can give right to vote."
    //     );
        
    //     require(
    //         users[_user].isActive,
    //         "The voter already voted."
    //     );
        
    //     User storage userData = users[_user];
    //     require(
    //         userData.accountNumber==_acctNum,
    //         "The voter already voted."
    //     );

        
    //     userData.data.push(_data);
    // }














}
