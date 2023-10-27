// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

interface Denz {
  function balanceDenzicle(address owner) external view returns(uint256);
}

contract DenzCoin is Initializable, ERC20Upgradeable, OwnableUpgradeable {
  Denz public denzicle;

  string private constant _name = "DenzCoin";
  string private constant _symbol = "DzCn";

  uint256 public START;
  bool claimable = true;

  mapping(address => uint256) public claimableCoins;
  mapping(address => uint256) public lastClaimed;
  mapping(address => bool) public claimableAddresses;

  function initialize(address denzicleAddress) public initializer{
    __ERC20_init_unchained(_name, _symbol);
    denzicle = Denz(denzicleAddress);
    START = block.timestamp;
  }

  
}