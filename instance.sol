pragma solidity ^0.8.0;
import "./DaughterContract.sol";

contract MomContract {
    string public name;
    uint256 public age;
    DaughterContract public daughter;

    constructor(
        string memory _momsName,
        uint256 _momsAge,
        string memory _daughtersName,
        uint256 _daughtersAge
    ) public {
        daughter = new DaughterContract(_daughtersName, _daughtersAge);
        name = _momsName;
        age = _momsAge;
    }
}

contract DaughterContract {
    string public name;
    uint256 public age;

    constructor(string memory _daughtersName, uint256 _daughtersAge) public {
        name = _daughtersName;
        age = _daughtersAge;
    }
}
