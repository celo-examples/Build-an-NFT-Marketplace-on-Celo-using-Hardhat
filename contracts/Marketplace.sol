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