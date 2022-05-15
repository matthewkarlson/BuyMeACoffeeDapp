//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
//deployed to 0x954697DB574F9C2cF653E16131b95D08AC20c940

contract BuyMeACoffee {
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    Memo[] memos;

    address payable owner;

    constructor()
    {
        owner = payable(msg.sender);
    }
    /**
     * @dev buy a coffee for contract owner
     * @param _name name of coffee buyer
     * @param _message nice message for the owner
     */
    function buyCoffee(string memory _name, string memory _message) public payable{

        require(msg.value > 0 ,"You can't be a coffee cause you dont have enough eth!");
        //add memo to storage
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));
        //emit a log event when new memo is created
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
        
    }
    address payable newTipAddress = owner;
    function changeTipAddress(address payable _newTipAddress) public{
        require(msg.sender==owner,"You do not have permission to change the address");
        newTipAddress= _newTipAddress;
    }

    /**
     * @dev Send balance stored in contract to owner address
     */
    function withdrawTips() public{
        require(msg.sender ==  newTipAddress, "You don't have permission to access this function");
        newTipAddress.transfer(address(this).balance);
    }

    /**
     * @dev Retrieves all memos stored in contract
     */
    function getMemos() public view returns(Memo[] memory){
        return memos;
    }


}
