//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
//deployed to 0xB16F3a66D064969b3c8509A2929d1bDC583CD842

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
    function changeTipAddress(address payable newTipAddressp) public{
        require(msg.sender==owner);
        newTipAddress=newTipAddressp;
    }

    /**
     * @dev Send balance stored in contract to owner address
     */
    function withdrawTips() public{
        newTipAddress.transfer(address(this).balance);
    }

    /**
     * @dev Retrieves all memos stored in contract
     */
    function getMemos() public view returns(Memo[] memory){
        return memos;
    }


}
