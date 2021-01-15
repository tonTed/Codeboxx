pragma solidity ^0.5.0;

contract MaterialProvider {

    uint public steel_panel = 0;
    uint public rails = 0;
    uint public sensor = 0;
    uint public steel_sheet = 0;
    uint public pulley = 0;
    uint public motor = 0;
    uint public steelcable = 0;
    uint public ledlight = 0;
    uint public button = 0;
    uint public screen = 0;
    uint public controller = 0;

    function setData(uint256[11] memory datas) public {
        steel_panel += datas[0];
        rails += datas[1];
        sensor += datas[2];
        steel_sheet += datas[3];
        pulley += datas[4];
        motor += datas[5];
        steelcable += datas[6];
        ledlight += datas[7];
        button += datas[8];
        screen += datas[9];
        controller += datas[10];
    }

    function getData() public view returns(uint256[11] memory){

        uint256[11] memory data = [
            steel_panel,
            rails,
            sensor,
            steel_sheet,
            pulley,
            motor,
            steelcable,
            ledlight,
            button,
            screen,
            controller
        ];

        return data;
    }

}