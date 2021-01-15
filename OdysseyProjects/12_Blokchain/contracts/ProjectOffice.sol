pragma solidity ^0.5.0;

contract ProjectOffice {

    uint public controller = 60;
    uint public cage = 8;
    uint public motor = 8;
    uint public door = 36;
    uint public button = 76;
    uint public display = 8;
    // uint[] public elem = [2, 8, 8, 36, 76];

    function getData() public view returns(uint[6] memory){

        uint[6] memory data = [
            controller,
            cage,
            motor,
            door,
            button,
            display
        ];

        return data;
    }
}