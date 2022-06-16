//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "./GovernorElection.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import { DataTypes } from './libraries/DataTypes.sol';

contract ProposalElection is Ownable {
    ///////////////////////////////////////////////////////////////////////////
    /////////STRUCTS
    ///////////////////////////////////////////////////////////////////////////
    struct Proposal {
        uint id;
        string title;
        string description;
        string postId;
        uint256 expectedAmount; //stored in wei
        address owner;
        address payable target;

        uint votes;
        bool passed;
        bool transfered;
        address[] alreadyVoted;
        uint256 lastsFor;
    }

    ///////////////////////////////////////////////////////////////////////////
    /////////CONSTANTS
    ///////////////////////////////////////////////////////////////////////////
    uint PROPOSAL_LASTS_FOR = 60*1; // 1 minute 
    //60*60*24*7; // 7 days
    

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

    modifier beAGovernor() {
        DataTypes.Governor[] memory governors = governorElection.getLastElectionWinners();

        bool foundGovernor = false;
        for(uint i = 0; i < governors.length; i++) {
            foundGovernor = governors[i].owner == msg.sender;
        }
        require(foundGovernor, "You are not a governor");
        _;
    }


    ///////////////////////////////////////////////////////////////////////////
    /////////FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////
    //Donate function let's people donate some money to the vault.
    function donate() public payable {}

    function hasAddressAlreadyVoted(address addr, uint256 proposalId) public view returns (bool) {
        for (uint i = 0; i < proposals[proposalId].alreadyVoted.length; i++) {
            if (proposals[proposalId].alreadyVoted[i] == addr) {
                return true;
            }
        }
        return false;
    }

    
    //This method transfers the requested amount to the victim only if the request has been voted YES by the majority of the angels
    //TODO add check that only the proposal owner can call this function
    function approveProposal(uint256 proposalId) public beAGovernor{
        require(proposals[proposalId].passed == true, "This proposal has not been passed");
        require(proposals[proposalId].transfered == false, "This proposal has been approved already");
        
        proposals[proposalId].transfered = true;
        address payable targetAddress = proposals[proposalId].target;
        targetAddress.transfer(proposals[proposalId].expectedAmount);
    }

    function createProposal(
        string memory postId, 
        string memory title, 
        string memory description,
        address payable target,
        uint256 expectedAmount
        ) public beAGovernor {
        //TODO only governors can create proposals
        Proposal storage newProposal = proposals[proposalNum++];

        newProposal.id = proposalNum++;
        newProposal.title = title;
        newProposal.description = description;
        newProposal.postId = postId;
        newProposal.expectedAmount = expectedAmount;
        newProposal.owner = msg.sender;
        newProposal.target = target;

        newProposal.votes = 1;
        newProposal.passed = false;
        newProposal.transfered = false;
        newProposal.alreadyVoted.push(msg.sender);
        newProposal.lastsFor = block.timestamp + PROPOSAL_LASTS_FOR;
    }

    function vote(uint256 proposalId) public beAGovernor onlyWhenEligibleToVote(proposalId) onlyWhenProposalIsActive(proposalId) {
        proposals[proposalId].votes++;
        proposals[proposalId].alreadyVoted.push(msg.sender);
        //TODO instead of 2 votes, use the half of the total number of governors + 1
        if(proposals[proposalId].votes > 2) {
            proposals[proposalId].passed = true;
        }
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

    //This method gets back the current vault balance
    function getVaultBalance() public view returns (uint256){
        return address(this).balance; 
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