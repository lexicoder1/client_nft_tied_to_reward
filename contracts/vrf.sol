// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/VRFConsumerBase.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */
 
contract RandomNumberConsumer is VRFConsumerBase {
    
    bytes32 internal keyHash;  
    uint256 internal fee;
    
    uint256 public randomResult;

    uint public g;

    uint[] public claimedwishes;
    uint public counter=1; 
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * Chainlink VRF Coordinator address: 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK token address:                0xa36085F69e2889c224210F603D836748e7dC0088
     * Key Hash: 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     */
    constructor() 
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
    }
    
    /** 
     * Requests randomness 
     */
    function getRandomNumber() internal returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override   {
         
       oo(randomness ); 
        

    }

    function oo(uint randomness )internal returns(bool){
       uint check=  (randomness %5) + 1;
       uint count=1;
       if (counter<=1){
           claimedwishes.push(check);
          randomResult = (randomness %5) + 1;  
               
       }

      if (counter>1){
         for (uint i;i<claimedwishes.length;i++ ){
         count++;
        if (claimedwishes[i]==check){
          
          if (count==5){
               return true;
          }
        
        getRandomNumber() ; 
          return true;

         }

       
        
     

         }
         randomResult = (randomness %5) + 1; 
         claimedwishes.push(randomResult);
        }

         if (counter<=1){
        
           counter++;
       }



    
    }

    function ddd()public {
     getRandomNumber() ;  
        
       
    }

    function rr()public view returns(uint[] memory) {

      return  claimedwishes; 
    } 

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}