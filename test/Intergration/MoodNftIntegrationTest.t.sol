// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft public moodNft;
    DeployMoodNft public deployer;
    address public USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        string memory tokenUri = moodNft.tokenURI(0);
        console.log("tokenUri:", tokenUri);
    }
}
