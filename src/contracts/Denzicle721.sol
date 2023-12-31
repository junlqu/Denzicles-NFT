// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Denzicle721 is ERC721EnumerableUpgradeable, OwnableUpgradeable {
  bool public mintable = false;

  string public baseURI;
  uint256 public maxSupply;         // Total number of Denzicles
  uint256 public maxCount;          // Total number of Denzicles and Denzerms
  uint256 public denzermCount = 0;  // The Denzerm count currently
  uint256 public price;             // The price to mint a Denzicle

  mapping(address => uint256) public balanceDenzicle;
  mapping(uint256 => address) public denzicleOwners;

  /**
   * Mints a collection of denzicles to a list of recipients, one to one
   * @param _recipients an array of wallets to airdrop to
   * @param _denzicles an array of denzicles to airdrop
   */
  function airdrop(address[] memory _recipients, uint256[] calldata _denzicles) external onlyOwner {
    require(_recipients.length == _denzicles.length, "Arrays are different sizes!");
    for (uint256 i; i < _denzicles.length; i++) {
      require(_recipients[i] != address(0), "Address 0 returned!");
      _safeMint(_recipients[i], _denzicles[i]);
      balanceDenzicle[_recipients[i]]++;
    }
  }

  /**
   * Mints a selected number of Denzicles
   * @param numberOfMints the number of new Denzicles to be created
   */
  function mint(uint256 numberOfMints) public payable {
    uint256 supply = totalSupply();
    require(mintable, "Cannot mint new Denzicles currently!");
    require(numberOfMints > 0 && numberOfMints <= 3, "Number of mints must be between 1 and 3!");
    require(supply + numberOfMints <= maxSupply, "Number of mints exceed max supply!");
    require(price * numberOfMints == msg.value, "Incorrect payment amount!");

    for (uint256 i; i < numberOfMints; i++) {
      _safeMint(msg.sender, supply + i);
      balanceDenzicle[msg.sender]++;
    }
  }

  /**
   * Returns the list of Denzicles owned by a wallet
   * @param owner the address of the wallet
   */
  function tokensOfOwner(address owner) external view returns(uint256[] memory) {
    uint256 tokenCount = balanceOf(owner);
    uint256[] memory tokens = new uint256[](tokenCount);

    for (uint256 i; i < tokenCount; i++) {
      tokens[i] = tokenOfOwnerByIndex(owner, i);
    }

    return tokens;
  }

  /**
   * Returns the list of all Denzicle owners
   */
  function ownersOfTokens() external view returns (address[] memory) {
    uint256 tokenCount = totalSupply();
    address[] memory owners = new address[](tokenCount);

    for (uint256 i; i < tokenCount; i++) {
      owners[i] = ownerOf(i);
    }

    return owners;
  }

  /**
   * Returns the list of all Denzerm owners
   */
  function ownersOfDenzerms() external view returns (address[] memory) {
    address[] memory owners = new address[](denzermCount);

    for (uint256 i; i < denzermCount; i++) {
      owners[i] = ownerOf(i);
    }

    return owners;
  }

  /**
   * Withdraws earnings to the owner of the contract
   */
  function withdraw() public onlyOwner {
    uint256 bal = address(this).balance;
    payable(msg.sender).transfer(bal);
  }

  /**
   * Toggles whether users can mint
   */
  function toggleMintable() public onlyOwner {
    mintable = !mintable;
  }

  /**
   * Updates the base price of Denzicles
   * @param newPrice the price to be updated to
   */
  function setPrice(uint256 newPrice) public onlyOwner {
    price = newPrice;
  }

  /**
   * Updates the currently used URI
   * @param newURI the new URI address
   */
  function setBaseURI(string memory newURI) public onlyOwner {
    baseURI = newURI;
  }
}