pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

/**
 * The ExampleERC721 contract does this and that...
 */
contract ExampleERC721 is ERC721Token{
	address private creator; //require this field in all uploaded contracts
	uint256 constant private price = 50 ether;
	bytes32 constant private creatorName = "Billy Lau";
	bytes32 constant private creatorBio = ""; //IPFS address
	bytes32 constant private creatorDisplayImage = ""; //IPFS address

	bool private donateLimitReached = false;

	event Donated(address donor);
	
	//Constructor
	function ExampleERC721 () {
		creator = msg.sender;
	}	

	//Getters
	function getCreatorAddress () public returns(address) {
		return(creator);
	}

	function getCreatorName () public returns(bytes32) {
		return(creatorName);
	}

	function getCreatorBio () public returns(bytes32) {
		return(creatorBio);
	}
	
	function getCreatorDisplayImage () public returns(bytes32) {
		return(creatorDisplayImage);
	}
	
	//Mint
	function mint () public payable{
		require(!donateLimitReached); //check if someone has already donated
		require(msg.value >= price); //check if donation amount is greater or equal to requested amount
		_mint(msg.sender,0); //create the 0th token and send it to the donor
		creator.transfer(msg.value); //transfer the donation ETH amount to the creator
		Donated(msg.sender); //fire an event signalling donation has been sucessful
		donateLimitReached = true; //flag to prevent multiple donations to the same token
	}
	


	function tokenMetadata (uint256 _tokenId) constant returns(string) {
		return("testIpfsAddress");
	}
	

}


