// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract Game is ERC1155URIStorage {
    address owner;
    uint256 tokenId = 1;

    string public _baseURI =
        "https://gateway.pinata.cloud/ipfs/QmdNXTUwxkeDf9Rm3cw9cKGiXtxXTgGDfaAvSkFgLfUjtP/";

    constructor() ERC1155("") {
        owner = msg.sender;
    }

    function mint(uint256 tokenAmount) external payable {
        require(msg.value == 190, "please enter valid value i.e. 190");

        string memory tokenURI = string(
            abi.encodePacked(_baseURI, Strings.toString(tokenId), ".json")
        );

        _setURI(tokenId, tokenURI);

        _mint(msg.sender, tokenId, tokenAmount, "");

        tokenId++;
    }
}
