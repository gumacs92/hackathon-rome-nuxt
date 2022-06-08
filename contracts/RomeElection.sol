//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

contract RomeElection {
    ///////////////////////////////////////////////////////////////////////////
    /////////STRUCTS
    ///////////////////////////////////////////////////////////////////////////
    struct CandidateInput {
        string name;
        string description;
    }

    struct Candidate {
        uint id;
        string name;
        string description;
        address owner;
    }

    struct Election {
        uint256 electionStartsAt;
        uint256 electionEndsAt;
        uint candidateNum;
        mapping(uint => Candidate) candidates;
    }


    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    uint ELECTION_START_IN = 60*60*24*1; // 1 days
    uint ELECTION_LASTS_FOR = 60*60*24*7; // 7 days
    

    ///////////////////////////////////////////////////////////////////////////
    /////////PROPERTY VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    uint256 candidateNumber = 0;

    uint256 electionNum;
    mapping(uint256 => Election) public elections;

    // The mapping of the current candidate votes id => votes
    mapping(uint => uint) public candidateVotes;

    address[] alreadyVoted;

    

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
        for (uint i = 0; i < elections[electionNum-1].candidateNum; i++) {
            if (elections[electionNum-1].candidates[i].owner == addr) {
                return true;
            }
        }
        return false;
    }

    function hasAddressAlreadyVoted(address addr) public view returns (bool) {
        for (uint i = 0; i < alreadyVoted.length; i++) {
            if (alreadyVoted[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function setElectionLastsFor(uint256 secondsToLast) public{
        //TODO require that only the owner can call this function
        ELECTION_LASTS_FOR = secondsToLast;
    }

    function applyAsCandidate(CandidateInput memory input) public onlyWhenElectionIsNotActive {
        elections[electionNum-1].candidates[elections[electionNum-1].candidateNum++] = Candidate({
            id: candidateNumber++,
            name: input.name,
            description: input.description,
            owner: msg.sender
        });
    }

    function vote(uint256 voteForId) public onlyWhenElectionIsActive onlyWhenEligibleToVote {
        candidateVotes[voteForId]++;
        alreadyVoted.push(msg.sender);
    }

    // this methods should be called every time when someone visits the site
    function checkElection() public {
        if (elections[electionNum-1].electionStartsAt <= block.timestamp && elections[electionNum-1].electionEndsAt >= block.timestamp) {
            // election is active => do nothing
        } else {
            // election is not active
            if(block.timestamp > elections[electionNum-1].electionEndsAt){
                // election is over => close it
                //craete new election by incrementing the election num
                Election storage election = elections[electionNum++];

                election.electionStartsAt = block.timestamp + ELECTION_START_IN;
                election.electionEndsAt = block.timestamp + (ELECTION_START_IN+ELECTION_LASTS_FOR);
            } else {
                // election has not yet started => do nothing
            }
        }
    }


}