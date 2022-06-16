//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

library DataTypes {

    struct Election {
        uint256 electionStartsAt;
        uint256 electionEndsAt;
        Governor[] candidates;
        address[] alreadyVoted;
    }

    struct Governor {
        uint id;
        string name;
        string description;
        address owner;
        uint votes;
    }
}