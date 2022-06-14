//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./GovernorElection.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ProposalElection is Ownable {
    ///////////////////////////////////////////////////////////////////////////
    /////////STRUCTS
    ///////////////////////////////////////////////////////////////////////////
    struct Proposal {
        uint id;
        string title;
        string description;
        string postId;
        address owner;
        uint votes;
        bool passed;
        address[] alreadyVoted;
        uint256 lastsFor;
    }

    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    uint PROPOSAL_LASTS_FOR = 60*60*24*7; // 7 days
    

    ///////////////////////////////////////////////////////////////////////////
    /////////PROPERTY VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    GovernorElection governorElection;

    uint256 proposalNum;
    Proposal[] proposals;
    

    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTRUCTOR
    ///////////////////////////////////////////////////////////////////////////
    constructor(GovernorElection _governorElection) {
        governorElection = _governorElection;
    }
    

    ///////////////////////////////////////////////////////////////////////////
    /////////MODIFIERS
    ///////////////////////////////////////////////////////////////////////////
    modifier onlyWhenEligibleToVote(uint256 proposalId) {
        require(hasAddressAlreadyVoted(msg.sender, proposalId) == false, "You have already voted on proposal");
        _;
    }

    modifier onlyWhenProposalIsActive(uint256 proposalId) {
        require(proposals[proposalId].lastsFor >= block.timestamp && proposals[proposalId].passed == false, "Proposal is not active");
        _;
    }


    ///////////////////////////////////////////////////////////////////////////
    /////////FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////
    function hasAddressAlreadyVoted(address addr, uint256 proposalId) public view returns (bool) {
        for (uint i = 0; i < proposals[proposalId].alreadyVoted.length; i++) {
            if (proposals[proposalId].alreadyVoted[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function createProposal(string memory postId, string memory title, string memory description) public {
        //TODO only governors can create proposals
        Proposal storage newProposal = proposals[proposalNum++];

        newProposal.id = proposalNum++;
        newProposal.title = title;
        newProposal.description = description;
        newProposal.postId = postId;
        newProposal.owner = msg.sender;
        newProposal.votes = 1;
        newProposal.passed = false;
        newProposal.alreadyVoted.push(msg.sender);
        newProposal.lastsFor = block.timestamp + PROPOSAL_LASTS_FOR;
    }

    function vote(uint256 proposalId) public onlyWhenEligibleToVote(proposalId) onlyWhenProposalIsActive(proposalId) {
        //TODO only governors can vote on proposals
        //TODO if more than half of the governors vote, then the proposal will be passed
        proposals[proposalId].votes++;
        proposals[proposalId].alreadyVoted.push(msg.sender);
    }

    function getProposals() public view returns(Proposal[] memory) {
        //count the active proposals
        uint activeProposalNum = 0;
        for(uint i = 0; i < proposalNum; i++) {
            //return only active proposals
            if(proposals[i].lastsFor >= block.timestamp && proposals[i].passed == false) {
               activeProposalNum++;
            }
        }

        //create an array of active proposals
        Proposal[] memory activeProposals = new Proposal[](activeProposalNum);

        //copy the active proposals to the array
        for(uint i = 0; i < proposalNum; i++) {
            //return only active proposals
            if(proposals[i].lastsFor >= block.timestamp && proposals[i].passed == false) {
                activeProposals[i] = proposals[i];
            }
        }

        return activeProposals; //return the array
    }

    ///////////////////////////////////////////////////////////////////////////
    /////////ONLY OWNER FUNCTIONS FOR DEBUGGING
    ///////////////////////////////////////////////////////////////////////////
    function setProposalLastsFor(uint256 proposalLastsFor) onlyOwner public{
        PROPOSAL_LASTS_FOR = proposalLastsFor;
    }

    function passProposal(uint256 proposalId) onlyOwner public{
        proposals[proposalId].passed = true;
    }

    function forceApplyAsCandidate(string memory postId, string memory title, string memory description) public onlyOwner {
        Proposal storage newProposal = proposals[proposalNum++];

        newProposal.id = proposalNum++;
        newProposal.title = title;
        newProposal.description = description;
        newProposal.postId = postId;
        newProposal.owner = msg.sender;
        newProposal.votes = 1;
        newProposal.passed = false;
        newProposal.alreadyVoted.push(msg.sender);
        newProposal.lastsFor = block.timestamp + PROPOSAL_LASTS_FOR;
    }
}