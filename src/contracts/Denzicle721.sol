// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Denzicle is OwnableUpgradeable, ERC721Upgradeable {
  event StatusChange();

  string public baseURI;
  uint256 public maxSupply;
  uint256 public maxCount;
  uint256 public price;

  mapping(address => uint256) public balanceDenzicle;
  mapping(uint256 => address) public owners;

  function mint(uint256 numberOfMints) public payable {

  }

  function tokensOfOwner(address owner) external view returns(uint256[] memory) {

  }


}