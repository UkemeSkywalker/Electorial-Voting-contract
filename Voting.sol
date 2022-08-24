// SPDX-License-Identifier: GPT-3

pragma solidity ^0.8.4;

import "./CompareStrings.sol";

contract Voting {

// Government should be able to create and delete a Political Party
// Party should be able to accept candidate
// Government should be able to conduct an election
// Any user should be able to vote.
// voting last for a specific time
// Election result can only be called after the elapse time, only by the government

using CompareStrings for string;

address government;

struct candidateList{
    address candidateAddress;
    string candidateName; 
}

struct politicalParty{  
        string partyName;
        string partySymbol;
        uint256 partyId;
}

struct candidateElect{
    string candidateName;
    string partyName;
    uint voteCount;
}

uint ballotCount;

event partyCreated(uint indexed partyId, string message,  string partyName , string partySymbol );
event candidateRegistered(address candidateAddress,string candidateName );

//create government as owner

constructor (address _government)  { 
    government = _government;
}


modifier onlyGovernment() {
    require(msg.sender == government);
    _;
}

// store all political parties here
politicalParty[] _politicalParty;

// Stores all candidates;
candidateList [] public allCandidates ;


mapping (uint => politicalParty ) politicalPartyId;
mapping(address => mapping(string => politicalParty)) candidateApplication;

mapping (string => candidateList) candidateListNames;



 // Here the Government which is the owner of the contract, 
 // creates a political party

function createPoliticalParty(string memory _partyName, uint _partyId, string memory _partySymbol) external onlyGovernment {

    // government can not create more than 5 parties
    require(_partyId <= 5, "Error: The government can not create more than 5 Political Parties");
    
    // write a condition to check if party already exist using _partyId
    politicalParty storage party = politicalPartyId[_partyId];
    party.partyName = _partyName;
    party.partySymbol   = _partySymbol;
    party.partyId = _partyId;

    _politicalParty.push(politicalParty({
        partyName : _partyName,
        partySymbol: _partySymbol,
        partyId : _partyId
    }));


    emit partyCreated(
        _partyId, 
        "You have created a new party",
        _partyName,
        _partySymbol
    );

    }

    // View all Political Parties
    function showAllPoliticalParties() public  view returns(politicalParty[] memory) {
        return _politicalParty;
    }

    // government can remove political party
    function removePoliticalParty(uint index) external onlyGovernment{
        for (uint256 i = index ; i < _politicalParty.length - 1; i++) {
            _politicalParty[i] = _politicalParty[i + 1];
        }
        _politicalParty.pop();
    }



// Anybody can apply as a candidate to any party

    function candidateRegistration( address _candidateAddress, string memory _candidateName,  uint _partyIndex)public {
        candidateApplication[_candidateAddress][_candidateName] = _politicalParty[_partyIndex + 1];

        candidateList storage c = candidateListNames[_candidateName];
        
        c.candidateAddress =_candidateAddress;
        c.candidateName = _candidateName;

        allCandidates.push(candidateList({
            candidateAddress : _candidateAddress,
            candidateName : _candidateName
        }));

        emit candidateRegistered(_candidateAddress, _candidateName);

    }

    // Returns a single Candidate

    function returnSingleCandidates(address _candidateAddress, string memory _candidateName)public view returns(politicalParty memory) {
        return candidateApplication[_candidateAddress][_candidateName];
    }


    // Returns all Candidate;
    function returnAllCandidates() public view returns(candidateList [] memory){
        return allCandidates;
    }

    // Write a function to remove candidates


    // Government should be able to conduct an election
    // Government would list out Candidates and their parties eligible for election
    function createBallotPaper(string memory _candidateName) external view onlyGovernment{
        string memory name;

        // Loop through Arry to find candidate name
        for(uint i = 0; i < allCandidates.length; i++ ){
            name = allCandidates[i].candidateName; 
            
            // check if candidate is registered
            // compare the hash or both name to see if it exist in storage

            bool check = name.compare(_candidateName);

            if(check == true){
                
            }
        }

    }

}