// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.26; 

import './DimaToken.sol';
 
contract CallNft { 

    DimaToken token;
 
    function callNft() public payable { 

        token = DimaToken(0xd3f5d75daf06079e8C2d46Daa319a38AB72e237A);

        address contractAdr = 0xd3f5d75daf06079e8C2d46Daa319a38AB72e237A; 
 
        (bool succes, ) = contractAdr.call{value: msg.value}(abi.encodeWithSignature("changePriceForMint(uint))", 1)); 
 
        require(succes, "1"); 
 
        (bool suc, ) = contractAdr.call{value: msg.value}(abi.encodeWithSignature("mint(uint)", 2)); 
 
        require(suc, "2"); 
 
        (bool s, ) = contractAdr.call{value: msg.value}(abi.encodeWithSignature("withdrawToOwner()")); 
 
        require(s, "3"); 
    } 
}