pragma solidity ^0.8.0;

contract A {
    function f1() public pure virtual returns (string memory) {
        return "this is contract a";
    }

    function f2() public pure returns (string memory) {
        return "this is contract a";
    }

    function f3() public pure virtual returns (string memory) {
        return "this is contract a";
    }
}

contract B is A {
    function f1() public pure override returns (string memory) {
        return "this is contract b";
    }

    function f3() public pure override returns (string memory) {
        return "this is contract b";
    }
}
