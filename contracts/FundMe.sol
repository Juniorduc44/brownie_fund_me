// SPDX-License-Identifier: MIT
// version for main Brownie Fund Me contract
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256; //only using this if prior to solidity <0.7.9

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner; //this creates a variable for owner
    AggregatorV3Interface public priceFeed;

    constructor(address _pricefeed) public { //this will be the first thing contract does when created
        priceFeed = AggregatorV3Interface(_pricefeed);
        owner = msg.sender; //owner is set to the person to deploy contract
    }

    function fund() public payable{
        // $50
        uint256 minimumUSD = 50 * 10**18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;//msg.sender is the sender of the function call. msg.value is how much they sent.
        // what the ETH --> USD conversion rate is
        funders.push(msg.sender); //pushes address of sender to an array for funds sent
        }

    function getVersion() public view returns (uint256){       
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256){       
        // i comment the extra out because the code isnt whats getting grabbed. could delete but commented instead. Deleting would make the code more clean though.
        (/*uint80 roundId*/,
        int256 answer,
        /*uint256 startedAt*/,
        /*uint256 updatedAt*/,
        /*uint80 answeredInRound*/) = priceFeed.latestRoundData();
        return uint256(answer * 1000000000);
    }

    //1gwei = 1000000000
    function getConversionRate(uint256 ethAmount) public view returns(uint256)
    
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000;
        return ethAmountInUsd;
        // 1,320.671500000000000000
        // .000013206715000000
    }

    function getEntranceFee() public view returns (uint256) {
        //minimumUSD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price +1;
    }



    modifier onlyOwner { //modifier will be run prior to following relevant function
        require(msg.sender == owner);
        _; //this marks where the relevant function will run, after the code above is established.
    }

    function withdraw() public payable onlyOwner { //onlyOwner perameter is set to this function
        require(msg.sender == owner); //this will require the person who owns the contract to be the only one allowed to withdraw all funds from contract
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex<funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }   

}