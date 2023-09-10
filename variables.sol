// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SolidityTest {
    uint256 public storedData; // State variable

    constructor() public {
        storedData = 10;
    }

    function getResult() public view returns (uint256) {
        uint256 a = 1; // local variable
        uint256 b = 2;
        uint256 result = a + b;
        return result; //access the local variable
    }
}


// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./IERC721.sol";
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol";
 import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";
 import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
 import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol";
//  import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol";

 contract MyNft is Context, ERC165, IERC721, IERC721Metadata  {

  
    using Address for address;
    using Strings for uint256;


    // Token name
    string private name;

    // Token symbol
    string private symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private owner;

    // Mapping owner address to token count
    mapping(address => uint256) private balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private operatorApprovals;

   
    constructor() {
        name = "MyNft";
        symbol = "MNFT";
    }


    
    function balanceOf(address _owner) external view returns (uint256){
       return balances[_owner];
    }

    function ownerOf(uint256 tokenId) external view returns (address){
        return owner[tokenId];
    }

    



    function transferFrom(address from, address to, uint256 tokenId) external  virtual  payable{

        require(owner[tokenId] == from , "wrong addess of token id");
        require(balances[from] != 0, "account doesnt have sufficient balance");
        require( operatorApprovals[from][msg.sender]==true , "approval has not been granted to you by the owner") ;

        balances[from]-=1;

        balances[to]+=1;

        owner[tokenId] = to;
        
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external virtual  payable{
    require(_checkOnERC721Received(from, to, tokenId,""), "ERC721: transfer to non ERC721Receiver implementer");

        require(owner[tokenId] == from , "wrong addess of token id");
        require(balances[from] != 0, "account doesnt have sufficient balance");
        require( operatorApprovals[from][msg.sender]==true , "approval has not been granted to you by the owner") ;

        balances[from]-=1;

        balances[to]+=1;

        owner[tokenId] = to;
        
    }



    function approve(address approved, uint256 tokenId) external payable{
        require(owner[tokenId] == msg.sender, "you are not the owner of the provoided token id");

        require(balances[msg.sender] != 0, "your account doesnt have sufficient balance");

        require(msg.sender== owner[tokenId] , "Only owner can approve the nft transfer");

        tokenApprovals[tokenId]=approved;

    }

    function setApprovalForAll(address operator, bool approved) external virtual{
         require(msg.sender != operator, "ERC721: approve to caller");
        operatorApprovals[msg.sender][operator] = approved;
    }



    function getApproved(uint256 tokenId) external virtual view returns (address){

        require(owner[tokenId] !=address(0),"NFT doesnt exist");
        
        return tokenApprovals[tokenId] ;

    }



    function isApprovedForAll(address _owner, address operator) external virtual view returns (bool){

        return (operatorApprovals[_owner][operator] == true);
        
    }

     function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }


}