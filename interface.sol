pragma solidity ^0.8.0;

interface Multiply {
    function getOutput() external view returns (uint256);
}

contract sample is Multiply {
    function getOutput() external view returns (uint256) {
        uint256 x = 12;
        uint256 y = 10;
        uint256 multval = x * y;
        return multval;
    }
}
