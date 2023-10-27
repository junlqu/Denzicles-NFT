// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Denzicle721.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface Denz {
  function burn(address _from, uint256 amount) external;
  function updateClaim(address _from, address _to) external;
}

contract Denzicle is Initializable, Denzicle721 {
  event DenzicleRevealed(uint256 denzicleId);

  string private constant _name = "Denzicle";
  string private constant _symbol = "Denz";

  struct DenzicleData {
    string name;
    string features;
    uint256 rangeLevel;
    uint256 damageLevel;
    uint256 speedLevel;
    uint256 cost;
    uint256 lives;
  }

  struct DenzermData {
    string name;
    string features;
  }

  Denz public denzCoin;

  mapping(uint256 => DenzicleData) public denzicleData;

  /**
   * @notice checks if the wallet owns a selected Denzicle
   */
  modifier denzicleOwner(uint256 denzicleId) {
    require(ownerOf(denzicleId) == msg.sender, "You do not own this Denzicle!");
    _;
  }

  /**
   * Constructor function
   * @param _maxSupply the maximum original denzicles
   * @param _maxCount the maximum count of all denzicle and denzerms
   * @param _price the price of minting denzicles
   * @param _uri the base URI
   */
  function initialize(uint256 _maxSupply, uint256 _maxCount, uint256 _price, string memory _uri) public initializer {
    __ERC721_init_unchained(_name, _symbol);
    __Ownable_init_unchained(msg.sender);
    maxSupply = _maxSupply;
    maxCount = _maxCount;
    price = _price;
    baseURI = _uri;
  }

  /**
   * Sets the address of the DenzCoin contract
   * @param _denzCoinAddress the DenzCoin address
   */
  function setDenzCoin(address _denzCoinAddress) external onlyOwner{
    denzCoin = Denz(_denzCoinAddress);
  }

  /**
   * Updates the transferFrom function to update local values as well
   * @param from the from address
   * @param to the too address
   * @param tokenId the Denzicle transfered
   */
  function transferFrom(address from, address to, uint256 tokenId) public override(ERC721Upgradeable, IERC721) {
    if (tokenId < maxCount) {
      denzCoin.updateClaim(from, to);
      balanceDenzicle[from]--;
      balanceDenzicle[to]++;
    }
    ERC721Upgradeable.transferFrom(from, to, tokenId);
  }

  /**
   * Updates the safeTransferFrom function to update local values as well
   * @param from the from address
   * @param to the too address
   * @param tokenId the Denzicle transfered
   */
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override(ERC721Upgradeable, IERC721) {
    if (tokenId < maxCount) {
      denzCoin.updateClaim(from, to);
      balanceDenzicle[from]--;
      balanceDenzicle[to]++;
    }
    ERC721Upgradeable.safeTransferFrom(from, to, tokenId, data);
  }
}