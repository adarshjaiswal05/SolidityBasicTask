pragma solidity ^0.8.0;

contract ChatApp {
    event chat(address sender, address receiver, string message);

    function sendMessage(address to, string memory message) public {
        emit chat(msg.sender, to, message);
    }
}
