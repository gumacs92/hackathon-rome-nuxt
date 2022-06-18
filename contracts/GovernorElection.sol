//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import { DataTypes } from './libraries/DataTypes.sol';

contract GovernorElection is Ownable {
    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    uint ELECTION_START_IN = 60*60*24*1; // 1 days
    uint ELECTION_LASTS_FOR = 60*60*24*7; // 7 days
    

    ///////////////////////////////////////////////////////////////////////////
    /////////PROPERTY VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    uint256 candidateNum = 1; //starts from 1 to help differentiate from 0 initalized candidates
    mapping(uint256 => DataTypes.Governor) candidates;

    uint256 electionNum = 1; //starts from 1 to help differentiate from 0 initalized elections
    mapping(uint256 => DataTypes.Election) elections;

    // The mapping of the current candidate votes id => votes
    mapping(uint => uint) candidateVotes;

    

    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////
    constructor() {
        DataTypes.Election storage election = elections[electionNum++];
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
        DataTypes.Governor memory newCandidate = DataTypes.Governor({
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

    function getLastElectionWinners() public view returns (DataTypes.Governor[] memory) {
        //return the top three voted candidates for the last election
        DataTypes.Governor[] memory winners = new DataTypes.Governor[](3);
        uint smallestVotedIndex = 0;

        DataTypes.Election storage lastElection = elections[electionNum-2];

        for(uint i = 0; i < lastElection.candidates.length; i++) {
            if (winners[smallestVotedIndex].votes <= lastElection.candidates[i].votes) {
                winners[smallestVotedIndex] = lastElection.candidates[i];

                for(uint j = 0; j < winners.length; j++){
                    if (winners[j].votes < winners[smallestVotedIndex].votes) {
                        smallestVotedIndex = j;
                    }
                }
            }
        }
        return winners;
    }

    function getCurrentElection() public view returns(DataTypes.Election memory) {
        DataTypes.Election memory election = elections[electionNum-1];
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
    //             DataTypes.Election storage election = elections[electionNum++];

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
    function setElectionLastsFor(uint256 electionLastsFor) public{
        //TODO require that only the owner can call this function
        ELECTION_LASTS_FOR = electionLastsFor;
    }

    function setElectionStartIn(uint256 electionStartIn) public{
        //TODO require that only the electionStartIn can call this function
        ELECTION_LASTS_FOR = electionStartIn;
    }

    function endCurrentElectionAndStartANewOne() public{
        //TODO require that only the owner can call this function
        DataTypes.Election storage election = elections[electionNum++];

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
        DataTypes.Governor memory newCandidate = DataTypes.Governor({
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