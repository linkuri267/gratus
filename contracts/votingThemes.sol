pragma solidity ^0.4.17;


contract Voting {
    
    struct Theme {
        string name;
        uint voteCount;
    }
    
    struct Voter {
        bool voted;
        uint vote;
        uint weight;
    }
    
    address public owner;
    string public name;
    mapping(address => Voter) public voters;
    theme[] public themes;
    
    event ElectionResult(string themeName, uint voteCount);
    
    function Election(string _name, string theme1, string theme2) public {
        owner = msg.sender;
        
        name = _name;
        //initialize list of themes to vote for
        themes.push(theme(theme1, 0));
        themes.push(theme(theme2, 0));
    }
    
    function authorize(address voter) public {
        //make sure only owner can authorize voting rights
        require(msg.sender == owner);
        //make sure voter has not already voted
        require(!voters[voter].voted);

        //assign voting rights
        voters[voter].weight = 1;
    }
    
    function vote(uint voteIndex) public {
        //make sure voter has not already voted
        require(!voters[msg.sender].voted);
        
        //record vote
        voters[msg.sender].vote = voteIndex;
        voters[msg.sender].voted = true;
        
        //increase theme vote count by voter weight
        themes[voteIndex].voteCount += voters[msg.sender].weight;
    }
    
    function end() public {
        //make sure only owner can end voting
        require(msg.sender == owner);
        
        //announce each themes results
        for(uint i=0; i < themes.length; i++){
            ElectionResult(themes[i].name, themes[i].voteCount);
        }
        
        //destroy the contract
        selfdestruct(owner);
    }
}