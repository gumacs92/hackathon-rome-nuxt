//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import { DataTypes } from './libraries/DataTypes.sol';

contract RomeToken is ERC20 {

//     mapping(string => mapping())

    constructor(uint256 initialSupply) ERC20("RomeToken", "RTK") {
        _mint(msg.sender, initialSupply);
    }

//     function joinEvent(string memory eventName) public {
//         emit Join(msg.sender);
//     }

//     function approve(address[] addresses) public {
//         for (uint i = 0; i < addresses.length; i++) {
//             _mint(addresses[i], 10);
//         }
//     }

}