// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error SmallSumForMint (uint requiredPrice);
error UnsuccesedWitdraw();

contract DimaToken is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {//https://etherscan.io/address/0xd3f5d75daf06079e8C2d46Daa319a38AB72e237A

    uint private priceForMint  = 100_000_000_000_000;
    string tokenUri = "https://ipfs.io/ipfs/bafkreievgibi55znfubyt7u4zeh45bq3vkh3jy3bsnkpj7edamos4jrepi";

    constructor(address initialOwner) ERC721("Dima", "DMA") Ownable(initialOwner) {
        ERC721._safeMint(initialOwner, 0);//я как владелец хочу обладать этим токеном после его создания
        ERC721URIStorage._setTokenURI(1, tokenUri);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function changePriceForMint(uint _price) external onlyOwner {
        priceForMint = _price;
    }

    function mint(uint tokenId) external payable {
        if (msg.value < priceForMint) {
            revert SmallSumForMint(priceForMint);
        }

        ERC721._safeMint(msg.sender, tokenId);
        ERC721URIStorage._setTokenURI(tokenId, tokenUri);
    }

    function withdrawToOwner() external onlyOwner {
         (bool _success, ) = (address(msg.sender)).call{value: address(this).balance}("");

        if (!_success) {
            revert UnsuccesedWitdraw();
        }
    }
}