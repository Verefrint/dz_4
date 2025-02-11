// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error SmallSumForMint (uint requiredPrice);
error UnsuccesedWitdraw();

contract DimaToken is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {//https://etherscan.io/address/0x194CEC4a9d9ccadf1eC93Af069D8267a97f3778A

    event CustomTransfer(address owner, uint price, string tokenUri);

    uint private priceForMint  = 100_000_000_000_000;
    string constant tokenUri = "https://ipfs.io/ipfs/bafkreievgibi55znfubyt7u4zeh45bq3vkh3jy3bsnkpj7edamos4jrepi";

    constructor(address initialOwner) ERC721("Dima", "DMA") Ownable(initialOwner) {
        ERC721._safeMint(initialOwner, 0);//я как владелец хочу обладать этим токеном после его создания
        ERC721URIStorage._setTokenURI(1, tokenUri);

        emit CustomTransfer(
            initialOwner,                    
            0,                                     
            tokenUri                        
        );
    }

    function transferFrom(address from, address to, uint256 tokenId) public override(IERC721, ERC721) {
        if (to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }

        emit CustomTransfer(
            to,                    
            0,                              
            tokenUri                        
        );
        
        address previousOwner = ERC721._update(to, tokenId, _msgSender());
        if (previousOwner != from) {
            revert ERC721IncorrectOwner(from, tokenId, previousOwner);
        }
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override(IERC721, ERC721) {
        emit CustomTransfer(
            to,                    
            0,                                   
            tokenUri                        
        );

        transferFrom(from, to, tokenId);
        ERC721Utils.checkOnERC721Received(_msgSender(), from, to, tokenId, data);
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
        require(msg.value >= priceForMint, SmallSumForMint(priceForMint));

        emit CustomTransfer(
            address(msg.sender),                    
            priceForMint,                        
            tokenUri                        
        );

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

