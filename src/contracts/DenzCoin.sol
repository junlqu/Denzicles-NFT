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

  uint256 public constant BASE_RATE = 10 ether;
  uint256 public START;
  bool claimable = true;

  uint256 public constant COOLDOWN = 86400 seconds; // 1 day
  uint256 public raffleReward = 500 ether;

  mapping(address => uint256) public claimableCoins;
  mapping(address => uint256) public lastClaimed;
  mapping(address => bool) public adminAddresses;

  /**
   * Constructor function
   * @param denzicleAddress the NFT address
   */
  function initialize(address denzicleAddress) public initializer{
    __ERC20_init_unchained(_name, _symbol);
    denzicle = Denz(denzicleAddress);
    START = block.timestamp;
  }

  /**
   * Burns a selected amount of tokens from a wallet address
   * @param _from the address to burn tokens from
   * @param _amount the amount of tokens to burn
   */
  function burn(address _from, uint256 _amount) external {
    require(msg.sender == address(denzicle) || adminAddresses[msg.sender], "Address does not have permission to burn!");
    _burn(_from, _amount);
  }

  /**
   * Updates the rewards claiming list with the total claimable amount of tokens from one address to another
   * This is used when a Denzicle is transferred to another wallet
   * @param _from the original wallet of the Denzicle
   * @param _to the new wallet of the Denzicle
   */
  function updateClaim(address _from, address _to) external {
    require(msg.sender == address(denzicle));
    if (_from != address(0)) {
      claimableCoins[_from] += getClaimable(_from);
      lastClaimed[_from] = block.timestamp;
    }
    if (_to != address(0)) {
      claimableCoins[_to] += getClaimable(_to);
      lastClaimed[_to] = block.timestamp;
    }
  }

  /**
   * Returns the claimable amount of DenzCoins for the selected user
   * @param user the address owner of the Denzicles
   */
  function getClaimable(address user) internal view returns(uint256) {
    return denzicle.balanceDenzicle(user) * BASE_RATE * (block.timestamp - (lastClaimed[user] >= START ? lastClaimed[user] : START)) / 86400;
  }
}