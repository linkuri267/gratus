pragma solidity ^0.4.17;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

/**
 * The exampleERC721 contract does this and that...
 */
contract exampleERC721 is ERC721Token{
	address private creator;
	uint256 constant private price = 50 ether;
	string constant private creatorName = "Billy Lau";
	string constant private creatorBio = "I am a third year student at the University of British Columbia. I aspire to be a future blockchain entrepreneur.";

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
		require(msg.value >= price);
		_mint(msg.sender,0);
		creator.transfer(msg.value);
		Donated(msg.sender);
	}
	


	function tokenMetadata (uint256 _tokenId) constant returns(string) {
		return("testIpfsAddress");
	}
	

}


