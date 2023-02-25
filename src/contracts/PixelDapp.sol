// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PixelDapp {

  struct Pixel{
    uint id;
    string hash;
    string description;
    uint tipAmount;
    uint likesCount;
    address payable author;
  }
  
  string public name;
  uint public imageCount = 0;

  mapping(uint => Pixel) public images;

  event CreatePixel( uint id, string hash, string description, uint tipAmount, address payable author );

  event TipPixel( uint id, string hash, string description, uint tipAmount, address payable author );

  event LikePixel( uint id, string hash, string description, uint likeCount );

  /** 
  @dev contract constructor: this is used to instatiate the contract
  */
  constructor () {

    name = "PixelDapp";

  }

  function upload(string memory _hash, string memory _description) public {

    require(bytes(_hash).length > 0, 'image is required');
    require(bytes(_description).length > 0, 'description is required');
    require(msg.sender != address(0));

    imageCount++;
    images[imageCount] = Pixel(imageCount, _hash, _description, 0,0, payable(msg.sender));

    // emit event
    emit CreatePixel(imageCount, _hash, _description, 0, payable(msg.sender));

  }

  function tip(uint _id) public payable {
    
    require(_id > 0 && _id <= imageCount); // make sure the id is valid
    Pixel memory _image = images[_id]; // get the image
    address payable _author = _image.author; // get the author

    // pay the author
    payable(address(_author)).transfer(msg.value);

    // increase tip amount
    _image.tipAmount = _image.tipAmount + msg.value;

    // update the image
    images[_id] = _image;

    // emit event
    emit TipPixel(_id, _image.hash, _image.description, _image.tipAmount, _author);

  }

  function like(uint _id) public payable {

    require(_id > 0 && _id <= imageCount); // make sure the id is valid
    Pixel memory _image = images[_id]; // get the image
    address payable _author = _image.author; // get the author

    // pay the author
    payable(address(_author)).transfer(msg.value);

    // increase like count
    _image.likesCount = _image.likesCount + 1;

    // update the image
    images[_id] = _image;

    // emit event
    emit LikePixel(_id, _image.hash, _image.description, _image.likesCount);

  }

}
