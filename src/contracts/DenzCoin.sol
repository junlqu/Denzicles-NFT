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
  uint256 public raffleReward;
  uint256 public START;
  bool claimable = true;

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
    raffleReward = 500 ether;
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
   * Claims the current claimable amount of DenzCoins
   */
  function claim() external {
    require(claimable, "Rewards are currently unclaimable!");
    _mint(msg.sender, claimableCoins[msg.sender] + getClaimable(msg.sender));
    claimableCoins[msg.sender] = 0;
    lastClaimed[msg.sender] = block.timestamp;
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

  /**
   * Sends out a set amount of DenzCoins to a list of recipients
   * @param recipients the list of recipients
   */
  function sendRaffle(address[] memory recipients) external onlyOwner {
    for (uint256 i; i < recipients.length; i++) {
      _mint(recipients[i], raffleReward);
    }
  }

  /**
   * Toggles whether users can claim DenzCoins
   */
  function toggleClaimable() public onlyOwner {
    claimable = !claimable;
  }

  /**
   * Updates the raffle reward
   * @param newPrize the new raffle reward
   */
  function setRafflePrice(uint256 newPrize) public onlyOwner {
    raffleReward = newPrize;
  }
}