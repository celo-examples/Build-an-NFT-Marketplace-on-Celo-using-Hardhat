title: Build an NFT Marketplace on Celo using Hardhat
description: Creating a simple NFT marketplace on the Celo Blockchain using Hardhat to create smart contracts.
authors:
  - name: ✍️ Joshua Obafemi
  - title: Technical Writer
  - url: https://github.com/jorshimayor
  - image_url: https://github.com/jorshimayor.png
tags: [celosage, solidity, celo, intermediate, hardhat]
hide_table_of_contents: false
slug: "/tutorials/bild-an-nft-marketplace-on-celo-using-hardhat"


# Introduction

Non-Fungible Tokens (NFTs) have revolutionized the way we view and own digital assets. They have become an increasingly popular means of buying and selling digital art, collectibles, and other unique items. In this article, we will explore how to build an NFT marketplace on the Celo blockchain using Hardhat, a popular Ethereum development environment. By the end of this article, you should have a good understanding of how to set up an NFT marketplace on Celo and how to deploy it to the blockchain.


# Prerequisites

In this tutorial, we're going to build an NFT Marketplace from scratch on the Celo blockchain so no prior knowledge is needed.

However, you can also go through this [tutorial](https://docs.celo.org/blog/tutorials/getting-started-on-celo-with-hardhat)


# Requirements

We'll need Metamask in this tutorial, install it from[ HERE](https://metamask.io/).

As at the time you're reading this tutorial, you should have the latest NodeJS 12.0.1+ version installed. Install it from[ HERE](https://nodejs.org/en)

A Celo wallet and some Celo testnet funds and familiarity with Solidity and the basics of blockchain development is required.

On your VScode IDE, install Solidity extension from[HERE](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity)



# Getting Started

Building an NFT marketplace on Celo blockchain using Hardhat involves several steps. Here's a step-by-step guide on how to do it:


## Step 1: Set up your development environment

To get started, you need to set up your VScode IDE. You'll need Node.js and npm installed on your machine. Once you have those installed, you can install Hardhat on your VScode IDE terminal using npm:


```
npm install --save-dev hardhat
```



## Step 2: Create a new Hardhat project

Once you have Hardhat installed, you can create a new project by running:


```
npx hardhat
```


This will create a new project with some sample contracts and tests.


## Step 3: Configure the Celo network

You need to configure Hardhat to connect to the Celo network. To do this, add the following code to your hardhat.config.js file:


```

require("@celo/hardhat-plugin");

 /** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
      accounts: {
        mnemonic: DEVCHAIN_MNEMONIC,
      },
    },
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [`${process.env.PRIVATE_KEY}`],
      chainId: 44787,
    },
    celo: {
      url: "https://forno.celo.org",
      accounts: [`${process.env.PRIVATE_KEY}`],
      chainId: 42220,
    },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
     }
  },
```


This code sets up the two Celo networks that you'll be using (Alfajores and Mainnet) and configures Hardhat to connect to them. You'll also need to create a secrets.json file that contains your private key for signing transactions on the network.


## Step 4: Write your NFT contract

Now you can write your NFT contract. Here's an example:


```solidity

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721 {

  using Counters for Counters.Counter;

  Counters.Counter private _tokenIds;

  constructor() ERC721("MyNFT", "NFT") {}

  function mintNFT(address recipient, string memory tokenURI)

    public

    returns (uint256)

  {

    _tokenIds.increment();

    uint256 newItemId = _tokenIds.current();

    _mint(recipient, newItemId);

    _setTokenURI(newItemId, tokenURI);

    return newItemId;

  }

}
```

This is a Solidity smart contract that defines an ERC721 Non-Fungible Token (NFT) called "MyNFT". Here is an explanation of each part of the code:

//SPDX-License-Identifier: MIT: SPDX (Software Package Data Exchange) is a standard way to declare the license of a software project. In this case, the license is set to MIT.

pragma solidity ^0.8.0;: This specifies that the contract is written in Solidity version 0.8.0 or later.

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";: This imports the ERC721 contract from the OpenZeppelin library, which is used to define the functionality of the NFT.

import "@openzeppelin/contracts/utils/Counters.sol";: This imports the Counters library from OpenZeppelin, which is used to keep track of the number of tokens that have been minted.

contract MyNFT is ERC721: This defines a new contract called MyNFT, which extends the ERC721 contract. This means that MyNFT inherits all the functions and variables of the ERC721 contract.

using Counters for Counters.Counter;: This sets up the Counters library to be used with the Counter struct.

Counters.Counter private _tokenIds;: This creates a private Counter variable called _tokenIds to keep track of the number of tokens that have been minted.

constructor() ERC721("MyNFT", "NFT") {}: This is the constructor function that sets the name and symbol of the NFT to "MyNFT" and "NFT" respectively.

function mintNFT(address recipient, string memory tokenURI) public returns (uint256): This is a public function that allows anyone to mint a new NFT. It takes in two parameters: the recipient address where the NFT will be sent and the tokenURI which is a unique identifier for the NFT.

_tokenIds.increment();: This increments the _tokenIds counter by one each time a new NFT is minted.

uint256 newItemId = _tokenIds.current();: This gets the current _tokenIds value, which is the ID of the newly minted NFT.

_mint(recipient, newItemId);: This mints a new NFT and assigns it to the specified recipient address with the newItemId ID.

_setTokenURI(newItemId, tokenURI);: This sets the tokenURI of the NFT to the specified value.

return newItemId;: This returns the newItemId, which is the ID of the newly minted NFT.


This contract inherits from the ERC721 contract from OpenZeppelin and adds a mintNFT function that allows you to mint a new NFT with a given token URI.


## Step 5: Write your marketplace contract

Next, you'll need to write your marketplace contract in a Marketplace.sol file. Here's an example:


```

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyMarketplace is ERC721Holder {
    using Counters for Counters.Counter;
    Counters.Counter private _listingIds;

    struct Listing {
        uint256 id;
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) private _listings;
    event ListingCreated(uint256 id, address seller, address nftContract, uint256 tokenId, uint256 price);
    event ListingCancelled(uint256 id);
    event ListingSold(uint256 id, address buyer, uint256 price);

    function createListing(address _nftContract, uint256 _tokenId, uint256 _price) external {
        require(_price > 0, "Price must be greater than zero");
        IERC721(_nftContract).safeTransferFrom(msg.sender, address(this), _tokenId);
        _listingIds.increment();
        uint256 listingId = _listingIds.current();
        _listings[listingId] = Listing(listingId, msg.sender, _nftContract, _tokenId, _price, true);
        emit ListingCreated(listingId, msg.sender, _nftContract, _tokenId, _price);
    }

    function cancelListing(uint256 _listingId) external {
        require(_listings[_listingId].seller == msg.sender, "Only seller can cancel the listing");
        require(_listings[_listingId].active == true, "Listing already cancelled or sold");
        IERC721(_listings[_listingId].nftContract).safeTransferFrom(address(this), msg.sender, _listings[_listingId].tokenId);
        _listings[_listingId].active = false;
        emit ListingCancelled(_listingId);
    }

    function buyListing(uint256 _listingId) external payable {
        require(_listings[_listingId].active == true, "Listing is not active");
        require(msg.value == _listings[_listingId].price, "Sent value is not correct");
        _listings[_listingId].active = false;
        IERC721(_listings[_listingId].nftContract).safeTransferFrom(address(this), msg.sender, _listings[_listingId].tokenId);
        payable(_listings[_listingId].seller).transfer(msg.value);
        emit ListingSold(_listingId, msg.sender, msg.value);
    }

    function getListing(uint256 _listingId) external view returns (Listing memory) {
        return _listings[_listingId];
    }

    function getActiveListings() external view returns (Listing[] memory) {
        uint256 activeListingCount = 0;
        for (uint256 i = 1; i <= _listingIds.current(); i++) {
            if (_listings[i].active == true) {
                activeListingCount++;
            }
        }
        Listing[] memory activeListings = new Listing[](activeListingCount);
        uint256 index = 0;
        for (uint256 i = 1; i <= _listingIds.current(); i++) {
            if (_listings[i].active == true) {
                activeListings[index] = _listings[i];
                index++;
            }
        }
        return activeListings;
    }
}
```
This is a Solidity smart contract that represents a basic marketplace for buying and selling ERC-721 tokens. ERC-721 is a standard interface for non-fungible tokens (NFTs) on the Ethereum blockchain.

The contract is named "MyMarketplace" and it inherits from the "ERC721Holder" contract, which is a utility contract that provides functionality for receiving ERC-721 tokens.

The contract contains a struct named "Listing", which represents a single listing in the marketplace. A listing has an ID, a seller address, an ERC-721 contract address, a token ID, a price, and an "active" flag that indicates whether the listing is still available for sale.

The contract also defines a mapping named "_listings", which maps listing IDs to their corresponding Listing struct. In addition, the contract has a private counter variable named "_listingIds", which is used to generate unique IDs for new listings.

The contract provides four public functions:

"createListing": allows a user to create a new listing by transferring an ERC-721 token to the contract and setting a price. The function checks that the price is greater than zero, increments the listing ID counter, and adds a new Listing struct to the _listings mapping. Finally, it emits a "ListingCreated" event.

"cancelListing": allows a seller to cancel a listing that they created. The function checks that the caller is the seller of the listing and that the listing is still active. If these conditions are met, the function transfers the ERC-721 token back to the seller and sets the "active" flag of the listing to false. Finally, it emits a "ListingCancelled" event.

"buyListing": allows a buyer to purchase a listing by sending the correct amount of Ether to the contract. The function checks that the listing is still active and that the sent value is equal to the listing price. If these conditions are met, the function transfers the ERC-721 token to the buyer, sends the Ether to the seller, and sets the "active" flag of the listing to false. Finally, it emits a "ListingSold" event.

"getActiveListings": allows anyone to retrieve a list of all active listings in the marketplace. The function loops through all the listings in the _listings mapping, counts the number of active listings, and creates a new array of Listing structs containing only the active listings. The function then returns this array.

The contract uses various OpenZeppelin libraries, including "IERC721" for interacting with ERC-721 tokens, "ERC721Holder" for receiving ERC-721 tokens, and "Counters" for generating unique IDs for new listings.

The first line of the contract "//SPDX-License-Identifier: MIT" is a special comment that specifies the license under which the contract code is released. In this case, the license is the MIT license, which is a permissive open-source license.







# Conclusion

In conclusion, building an NFT Marketplace on Celo using Hardhat is an exciting opportunity for developers and entrepreneurs to tap into the growing NFT market. With Celo's fast and low-cost blockchain infrastructure, developers can easily create NFT marketplaces that offer seamless trading experiences to users.

The integration of Hardhat makes the development process more streamlined and efficient, enabling developers to focus on building innovative features for their marketplaces.

Congratulations on building a marketplace on the Celo blockchain using Hardhat!!!



# Next Steps

Now that you've successfully built an NFT marketplace, you can build more exciting project using hardhat! Follow our tutorial page for more intriguing projects that can be built on the Celo blockchain [CeloSage Tutorials](https://docs.celo.org/tutorials?tags=hardhat).



# About the Author

Joshua Obafemi

I'm a Web3 fullstack developer and technical writer. You can connect with me on [GitHub](https://github.com/jorshimayor), [Twitter](https://twitter.com/jorshimayor), [Linkedin](https://www.linkedin.com/in/joshua-obafemi-ba2014199/).