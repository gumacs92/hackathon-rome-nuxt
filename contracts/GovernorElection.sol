//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GovernorElection is Ownable {
    ///////////////////////////////////////////////////////////////////////////
    /////////STRUCTS
    ///////////////////////////////////////////////////////////////////////////
    struct Candidate {
        uint id;
        string name;
        string description;
        address owner;
        uint votes;
    }

    struct Election {
        uint256 electionStartsAt;
        uint256 electionEndsAt;
        Candidate[] candidates;
        address[] alreadyVoted;
    }


    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    uint ELECTION_START_IN = 60*60*24*1; // 1 days
    uint ELECTION_LASTS_FOR = 60*60*24*7; // 7 days
    

    ///////////////////////////////////////////////////////////////////////////
    /////////PROPERTY VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    uint256 candidateNum = 0;
    mapping(uint256 => Candidate) candidates;

    uint256 electionNum;
    mapping(uint256 => Election) elections;

    // The mapping of the current candidate votes id => votes
    mapping(uint => uint) candidateVotes;

    

    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////
    constructor() {
        Election storage election = elections[electionNum++];
        election.electionStartsAt = block.timestamp + ELECTION_START_IN; //first election starts ELECTION_LASTS_FOR from now
        election.electionEndsAt = block.timestamp + (ELECTION_START_IN+ELECTION_LASTS_FOR); //and ends 2*ELECTION_LASTS_FOR from now
    }
    

    ///////////////////////////////////////////////////////////////////////////
    /////////MODIFIERS
    ///////////////////////////////////////////////////////////////////////////
    modifier onlyWhenElectionIsActive() {
        require(elections[electionNum-1].electionStartsAt <= block.timestamp && elections[electionNum-1].electionEndsAt >= block.timestamp, "Election is not active");
        _;
    }

    modifier onlyWhenElectionIsNotActive() {
        require(elections[electionNum-1].electionStartsAt > block.timestamp || elections[electionNum-1].electionEndsAt < block.timestamp, "Election is active");
        _;
    }

    modifier onlyWhenEligibleToVote() {
        require(hasCandidateByAddress(msg.sender) == false, "You are not eligible to vote, because you are a candidate");
        require(hasAddressAlreadyVoted(msg.sender) == false, "You have already voted");
        _;
    }

    ///////////////////////////////////////////////////////////////////////////
    /////////FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////
    function hasCandidateByAddress(address addr) public view returns (bool) {
        for (uint i = 0; i < elections[electionNum-1].candidates.length; i++) {
            if (elections[electionNum-1].candidates[i].owner == addr) {
                return true;
            }
        }
        return false;
    }

    function hasAddressAlreadyVoted(address addr) public view returns (bool) {
        for (uint i = 0; i < elections[electionNum-1].alreadyVoted.length; i++) {
            if (elections[electionNum-1].alreadyVoted[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function applyAsCandidate(string memory name, string memory description) public onlyWhenElectionIsNotActive {
        Candidate memory newCandidate = Candidate({
            id: candidateNum++,
            name: name,
            description: description,
            owner: msg.sender,
            votes: 0
        });

        candidates[newCandidate.id] = newCandidate;
        elections[electionNum-1].candidates.push(candidates[newCandidate.id]);
    }

    function vote(uint256 voteForId) public onlyWhenElectionIsActive onlyWhenEligibleToVote {
        //TODO only token holders are eligibel for voting
        //increment the vote mapping for the candidate
        candidateVotes[voteForId]++;
        //and increment its votes
        for(uint i = 0; i < elections[electionNum-1].candidates.length; i++) {
            if (elections[electionNum-1].candidates[i].id == voteForId) {
                elections[electionNum-1].candidates[i].votes++;
            }
        }
        //add the address to the alreadyVoted array
        elections[electionNum-1].alreadyVoted.push(msg.sender);
    }

    function getCurrentElection() public view returns(Election memory) {
        Election memory election = elections[electionNum-1];
        return election;
    }

    // this methods should be called every time when someone visits the site
    // function checkElection() public {
    //     if (elections[electionNum-1].electionStartsAt <= block.timestamp && elections[electionNum-1].electionEndsAt >= block.timestamp) {
    //         // election is active => do nothing
    //     } else {
    //         // election is not active
    //         if(block.timestamp > elections[electionNum-1].electionEndsAt){
    //             // election is over => close it
    //             //craete new election by incrementing the election num
    //             Election storage election = elections[electionNum++];

    //             election.electionStartsAt = block.timestamp + ELECTION_START_IN;
    //             election.electionEndsAt = block.timestamp + (ELECTION_START_IN+ELECTION_LASTS_FOR);
    //         } else {
    //             // election has not yet started => do nothing
    //         }
    //     }
    // }



    ///////////////////////////////////////////////////////////////////////////
    /////////FUNCTIONS FOR DEBUGGING
    ///////////////////////////////////////////////////////////////////////////
    function setElectionLastsFor(uint256 electionLastsFor) onlyOwner public{
        //TODO require that only the owner can call this function
        ELECTION_LASTS_FOR = electionLastsFor;
    }

    function setElectionStartIn(uint256 electionStartIn) onlyOwner public{
        //TODO require that only the electionStartIn can call this function
        ELECTION_LASTS_FOR = electionStartIn;
    }

    function endCurrentElectionAndStartANewOne() onlyOwner public{
        //TODO require that only the owner can call this function
        Election storage election = elections[electionNum++];

        election.electionStartsAt = block.timestamp;
        election.electionEndsAt = block.timestamp + (ELECTION_START_IN+ELECTION_LASTS_FOR);
    }


    function forceVote(uint256 voteForId) public {
        //TODO only token holders are eligibel for voting
        //increment the vote mapping for the candidate
        candidateVotes[voteForId]++;
        //and increment its votes
        for(uint i = 0; i < elections[electionNum-1].candidates.length; i++) {
            if (elections[electionNum-1].candidates[i].id == voteForId) {
                elections[electionNum-1].candidates[i].votes++;
            }
        }
        //add the address to the alreadyVoted array
        elections[electionNum-1].alreadyVoted.push(msg.sender);
    }

    function forceApplyAsCandidate(string memory name, string memory description) public {
        Candidate memory newCandidate = Candidate({
            id: candidateNum++,
            name: name,
            description: description,
            owner: msg.sender,
            votes: 0
        });

        candidates[newCandidate.id] = newCandidate;
        elections[electionNum-1].candidates.push(candidates[newCandidate.id]);
    }
}