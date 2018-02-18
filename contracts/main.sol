pragma solidity ^0.4.17;

/**
 * The main contract does this and that...
 */
contract main {

	struct Creator{
		address walletAddr;
		address[] contractAddr; //Addresses of contracts created by this creator
		string[] src; //IPFS addresses for contract source codes
		bool hasContract;
		uint256 contractCount; //Number of contracts created by this creator
	}

	struct Donor {
		address walletAddr;
		uint amountDonated;
	}

	Creator[] public creators; //array of all creators 
	Donor[] public donors; //array of all donors
	

	mapping (address => Creator) creatorAddressToCreator;
	mapping (address => Creator) contractAddressToCreator;

	mapping (address => bool) creatorAddressToIncludedFlag; //Flags for preventing duplicate random addresses 
	
	// mapping (address => address) private creatorToContract;
	// mapping (address => string) private creatorToSrc;
	
	// mapping (address => string) private creatorToName;
	// mapping (address => string) private creatorToBio;
	// mapping (address => string) private creatorToDisplayImage;

	//mapping (address => uint256) private donorToDonated;	

	bytes32 public seedHash;
	uint256 private totalContracts;
	uint256 private totalCreators;

	string private theme; //theme of the month
	
	function main () {
		totalContracts = 0;
		totalCreators = 0;
		seedHash = block.blockhash(block.number-1);	
	}

	//Returns an array of contract addresses submitted by the creator. Takes the creator address as input.
	function getContractFromCreator (address creatorAddress) returns(address[]) {
		address[] contractAddresses;
		require((creatorAddressToCreator[creatorAddress]).hasContract);
		for(uint i = 0; i < (creatorAddressToCreator[creatorAddress]).contractCount; i++){
			contractAddresses.push((creatorAddressToCreator[creatorAddress]).contractAddr[i]);
		}
		return(contractAddresses);	
	}

	//Creators will use this function to submit their contracts. Will exit if the contract creator field is not the message sender
	//Sender is the creator in this case
	function submitContract (address contractAddress, string ipfsHash) {
		ExampleERC721 submission;
		submission = ExampleERC721(contractAddress);
		address creatorAddress = submission.getCreatorAddress();
		require(creatorAddress == msg.sender);

		if(!(creatorAddressToCreator[creatorAddress].hasContract)){
			(creatorAddressToCreator[creatorAddress]).walletAddr = creatorAddress;
			(creatorAddressToCreator[creatorAddress]).contractAddr.push(contractAddress);
			(creatorAddressToCreator[creatorAddress]).src.push(ipfsHash);
			(creatorAddressToCreator[creatorAddress]).hasContract = true;
			(creatorAddressToCreator[creatorAddress]).contractCount ++;
			totalCreators ++;
			contractAddressToCreator[contractAddress] = creatorAddressToCreator[creatorAddress];
		}
		else{
			(creatorAddressToCreator[creatorAddress]).contractAddr.push(contractAddress);
			(creatorAddressToCreator[creatorAddress]).src.push(ipfsHash);
			(creatorAddressToCreator[creatorAddress]).contractCount ++;
			contractAddressToCreator[contractAddress] = creatorAddressToCreator[creatorAddress];
		}
		totalContracts ++;

	}

	//Returns one of either name, bio or display image URL depending on the field parameter
	//Commented because EVM cannot return dynamically sized items

	// function getCreatorInfoFromAddress (address creator, string field) returns(bytes32) { 
	// 	require(creatorToContract[creator] != 0); //Check if the creator has a contract stored in the mapping
	// 	require(keccak256(field) != keccak256(""));
	// 	address _cAddr = creatorToContract[creator];
	// 	ExampleERC721 _c;
	// 	_c = ExampleERC721(_cAddr);

	// 	if((keccak256(field) == keccak256("name"))||(keccak256(field) == keccak256("Name"))){
	// 		return(_c.getCreatorName());
	// 	}
	// 	else if((keccak256(field) == keccak256("bio"))||(keccak256(field) == keccak256("Bio"))){
	// 		return(_c.getCreatorBio());
	// 	}
	// 	else if((keccak256(field) == keccak256("displayImage"))||(keccak256(field) == keccak256("DisplayImage"))){
	// 		return(_c.getCreatorDisplayImage());
	// 	}
	// 	else{
	// 		return("");
	// 	}	
	// }

	//Returns n number of random contract addresses in an array. It will not return two contracts from the same creator. Pass in n as an input. 
	function getRandomContractAddress(uint256 n) returns(address[]) {
		uint256 neededCount;
		uint256 generatedCount = 0;
		uint256 random;
		address iterationAddress;
		address[] randomAddresses;

		if(totalCreators>=n){
			neededCount = n;
			while(generatedCount < neededCount){
				random = rand(0,totalCreators-1);
				Creator iterationCreator = creators[n];
				random = rand(0,iterationCreator.contractCount);
				if(creatorAddressToIncludedFlag[iterationCreator.walletAddr] == false){
					if(iterationCreator.hasContract){
						randomAddresses.push(iterationCreator.contractAddr[random]);
						generatedCount++;
						creatorAddressToIncludedFlag[iterationCreator.walletAddr] = true;
					}
				}
			}
		}
		else{
			neededCount = totalCreators;
			for(uint i = 0; i < neededCount; i++){
				iterationCreator = creators[i];
				if(iterationCreator.hasContract){
					random = rand(0,iterationCreator.contractCount);
					randomAddresses.push(iterationCreator.contractAddr[random]);
				}
			}
		}
		return(randomAddresses);
		//TODO: SET ALL INCLUDE FLAGS TO FALSE
	}

	//Returns a string containing the IPFS hash of the  ABI data of a contract. Pass the contract address you want to query the ABI of.
	function getAbiHashFromContract (address contractAddr) returns(string) {
		require(contractAddressToCreator[contractAddr].hasContract);
		uint contractIndex = 0;
		for(uint i = 0; i < contractAddressToCreator[contractAddr].contractCount; i++){
			if(contractAddressToCreator[contractAddr].contractAddr[i] == contractAddr){
				contractIndex = i;
			}
		}
		return(contractAddressToCreator[contractAddr].src[contractIndex]);
	}


	//Generate a random uint256 within the range [lowerBound,upperBound]
	function rand(uint256 lowerBound, uint256 upperBound) private returns (uint256){
		uint256 seedInt = uint(seedHash)/2;
		seedInt += now;
		return(uint(sha256(seedInt))%(upperBound-lowerBound)+lowerBound+1);
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
