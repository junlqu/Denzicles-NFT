// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Denzicle721.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

interface Denz {
  /**
   * Burns a selected amount of tokens from a wallet address
   * @param _from the address to burn tokens from
   * @param amount the amount of tokens to burn
   */
  function burn(address _from, uint256 amount) external;

  /**
   * Updates the rewards claiming list with the total claimable amount of tokens from one address to another
   * This is used when a Denzicle is transferred to another wallet
   * @param _from the original wallet of the Denzicle
   * @param _to the new wallet of the Denzicle
   */
  function updateClaim(address _from, address _to) external;
}

contract Denzicle is Initializable, Denzicle721 {
  event DenzicleRevealed(uint256 denzicleId);

  string private constant _name = "Denzicle";
  string private constant _symbol = "Denz";

  struct DenzicleData {
    string name;
    string features;
  }

  modifier denzicleOwner(uint256 denzicleId) {
    require(ownerOf(denzicleId) == msg.sender, "You do not own this Denzicle!");
    _;
  }

  Denz public denzCoin;

  mapping(uint256 => DenzicleData) public denzicleData;

  function initialize(uint256 _maxSupply, uint256 _price, string memory _uri) public initializer {
    __ERC721_init_unchained(_name, _symbol);
    __Ownable_init_unchained(msg.sender);
    maxSupply = _maxSupply;
    price = _price;
    baseURI = _uri;
  }
}