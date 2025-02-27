// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CannotFlipMoodIfNotOwner();

    uint256 private s_tokenCounter; // token数量，也可以表示当前创建第几个Nft，也就是tokenId
    string private s_sadSvgImageUri; // 伤心的svg
    string private s_happySvgImageUri; // 开心的svg

    // 定义用户是否开心或伤心
    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("MoodNft", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    // tokenUri的基础的URI前缀
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    // 铸造Nft Mood代币
    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        ++s_tokenCounter;
    }

    // 切换情绪
    function flipMood(uint256 tokenId) public {
        // 只有MoodNft的拥有者才可以切换心情
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CannotFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        } else {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        }
    }

    // 根据tokenId获取tokenUri
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUri;
        } else {
            imageURI = s_happySvgImageUri;
        }

        string memory tokenMetadata = string(
            abi.encodePacked(
                '{"name":"',
                name(),
                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                '"attributes": [{"trait_type": "moodiness", "value": 100}], ',
                '"image":"',
                imageURI,
                '"}'
            )
        );
        string memory base64String = Base64.encode(bytes(tokenMetadata));
        string memory tokenUri = string(
            abi.encodePacked(_baseURI(), base64String)
        );
        return tokenUri;
    }

    function getImageUrl(uint256 tokenId) public view returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUri;
        } else {
            imageURI = s_happySvgImageUri;
        }

        return imageURI;
    }
}
