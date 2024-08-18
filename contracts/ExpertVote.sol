// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract ExpertVote{



struct Candidate{  // create Candidate struct 
  
    uint  id;
   string  name;
   uint voteCount;
}

struct Voter{  // second step is create Voter struct
    bool authorized;
    bool voted;
    uint vote;

}

address public owner;   // and we made one person the owner 
string public electionName;

mapping (address=>Voter) public voters;  // who wil vote?

Candidate[] public candidates; // create "Candidate" ARRAY

uint public totalVotes;

modifier onlyOwner(){
  require(owner==msg.sender,"Caller is not Owner.");

    _;
}

event Winner(string name, uint voteCount); // announcing the champion to the outside world

constructor(string memory _electionName) {
    owner=msg.sender;
    electionName=_electionName;
}

function addCandidate(string memory _name) public onlyOwner{
    candidates.push(Candidate(candidates.length,_name,0));
}


function authorized(address _person) public  onlyOwner {
    voters[_person].authorized = true;
}

function vote(uint _candidateId) public {
    require(_candidateId < candidates.length, "Invalid candidate ID");
    require(!voters[msg.sender].voted,"You have already voted");
    require(voters[msg.sender].authorized,"You are not authorized to vote.");
    
    voters[msg.sender].voted=true;
    voters[msg.sender].vote = _candidateId;
  candidates[_candidateId].voteCount+=1;
      totalVotes+=1;

}


function end() public onlyOwner  returns (Candidate memory){
Candidate memory winningCandidate = candidates[0];
for (uint i = 1; i < candidates.length; i++) 
{
  if (candidates[i].voteCount>winningCandidate.voteCount) {
    winningCandidate= candidates[i];
  }
}
emit Winner(winningCandidate.name, winningCandidate.voteCount);
return winningCandidate;

}










    


}