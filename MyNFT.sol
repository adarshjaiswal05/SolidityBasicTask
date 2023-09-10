// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {
    //Token ID
    uint256 tokenID = 0;

    //contract Owner
    address contractOwner;

    //max no of nft
    uint256 maxSupply = 3;

    uint256 public totalSupply;

    string baseURI;

    // Mapping from owner to token id to token metadata
    mapping(string => bool) public metaDataExist;

    constructor() ERC721("MyNFT", "MNFT") {
        contractOwner = msg.sender;
    }

    function mint(address to, string memory metaData) external payable {
        require(
            totalSupply < maxSupply,
            "you have reached the max supply of token"
        );
        require(
            msg.value == 150,
            "please send a valid amount to buy nft ie 150 wei"
        );
        require(metaDataExist[metaData] == false, "meta data already exist");

        _mint(to, tokenID);

        _setTokenURI(tokenID, metaData);
        tokenID += 1;
        totalSupply += 1;
        metaDataExist[metaData] = true;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function contractFund() public view returns (uint256) {
        return address(this).balance;
    }

    bool private lockBalances;
    uint256 withdrawAloowance = 2000;

    bool internal locked;

    modifier noReenterancy() {
        require(!locked, "no reenterncy");
        locked = true;
        _;
        locked = false;
    }

    function withdrawEarning(uint256 amount) public noReenterancy {
        require(
            msg.sender == contractOwner,
            "only owner is allowed to take the earning"
        );
        require(
            withdrawAloowance >= amount,
            "insufficient allownace , you can take only take 2000 of the earning"
        );
        payable(msg.sender).transfer(amount);

        withdrawAloowance -= amount;
    }
}
