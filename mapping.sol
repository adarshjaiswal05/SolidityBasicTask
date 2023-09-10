pragma solidity ^0.8.0;

struct details {
    string name;
    uint256 age;
    string blood_grp;
}

contract Mapping {
    //created a simple mapping bw roll no and structure details and a function to set values

    mapping(uint256 => details) public roll_no;

    //creating a nested mapping
    mapping(address => mapping(uint256 => bool)) public valid_address;

    function setter(
        uint256 _roll_no,
        string memory name,
        uint256 age,
        string memory blood_grp
    ) public {
        require(
            bytes(roll_no[_roll_no].name).length == 0,
            "Error: Data already exists"
        );

        roll_no[_roll_no] = details(name, age, blood_grp);
        valid_address[msg.sender][_roll_no] = true;
    }
}
