pragma solidity ^0.4.17;

/**
 * The main contract does this and that...
 */
contract main {
	mapping (address => address) private creatorToContract;
	// mapping (address => string) private creatorToName;
	// mapping (address => string) private creatorToBio;
	// mapping (address => string) private creatorToDisplayImage;

	mapping (address => uint256) private donorToDonated;

	string private theme; //theme of the month
	
	function main () {
		
	}

	function getContractFromCreator (address creatorAddress) returns(address) {
		return(creatorToContract[creatorAddress]);		
	}

	//Creators will use this function to submit their contracts. Will exit if the contract creator field is not the message sender
	function submitContract (address contractAddress) {
		ExampleERC721 submission;
		submission = ExampleERC721(contractAddress);
		address creatorAddress = submission.getCreatorAddress();
		require(creatorAddress == msg.sender);
		creatorToContract[msg.sender] = contractAddress;
	}

	//Returns one of either name, bio or display image URL depending on the field parameter
	function getCreatorInfoFromAddress (address creator, string field) returns(bytes32) {
		require(creatorToContract[creator] != 0); //Check if the creator has a contract stored in the mapping
		require(keccak256(field) != keccak256(""));
		address _cAddr = creatorToContract[creator];
		ExampleERC721 _c;
		_c = ExampleERC721(_cAddr);

		if((keccak256(field) == keccak256("name"))||(keccak256(field) == keccak256("Name"))){
			return(_c.getCreatorName());
		}
		else if((keccak256(field) == keccak256("bio"))||(keccak256(field) == keccak256("Bio"))){
			return(_c.getCreatorBio());
		}
		else if((keccak256(field) == keccak256("displayImage"))||(keccak256(field) == keccak256("DisplayImage"))){
			return(_c.getCreatorDisplayImage());
		}
		else{
			return("");
		}
	}		
}

/**
 * The ExampleERC721 abstract contract
 */
contract ExampleERC721 {
	function getCreatorAddress() returns(address);
	function getCreatorName() returns(bytes32);
	function getCreatorBio() returns(bytes32);
	function getCreatorDisplayImage() returns(bytes32);
	
}
