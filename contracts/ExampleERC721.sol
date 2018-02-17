pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

/**
 * The exampleERC721 contract does this and that...
 */
contract exampleERC721 is ERC721Token{
	address private creator;
	uint256 constant private price = 50 ether;
	string constant private creatorName = "Billy Lau";
	string constant private creatorBio = "I am a third year student at the University of British Columbia. I aspire to be a future blockchain entrepreneur. Currently, I have student debt of amount $5000. I wish to raise funds so I can continue my education studying blockchain technology at Stanford.";
	bool private donateLimitReached = false;

	event Donated(address donor);
	
	//Constructor
	function exampleERC721 () {
		creator = msg.sender;
	}	

	//Getters
	function getCreatorAddress () returns(address) {
		return(creator);
	}

	function getCreatorName () returns(string) {
		return(creatorName);
	}

	function getCreatorBio () returns(string) {
		return(creatorBio);
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


