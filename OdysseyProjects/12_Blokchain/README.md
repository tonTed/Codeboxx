# MaterialProvider

## Tools used:
- Trufflesuite : Smart contracts made sweeter

- Ganache : One click Blockchain

- Metamask : Crypto wallet & gateway to blockchain apps

## Creating contracts:
#### File : /contracts/Material/Provider
1 - We use the solidity language to make the smartcontract:
```shell script
contract MaterialProvider {
}
```
2 - Adding variables to the contract :
```shell script
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
```
3 - Creating functions to set the data in the contract
```shell script
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
```
4 - Creating function to give the data to the next node
```shell script
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
```

## Compile and migrate the contracts:
#### File : /migration/2_deploy_contracts.js
1 - Creating migration file:
```javascript
var MaterialProvider = artifacts.require("MaterialProvider");
// Contract ProjectOffice for first node simulation
var ProjectOffice = artifacts.require("ProjectOffice");

module.exports = function(deployer) {
  deployer.deploy(MaterialProvider);
  deployer.deploy(ProjectOffice);
};
```
1 - Compile and migrate
```ruby
$ truffle compile     #this command create the json files of the contratc in th build folder
$ truffle migrate     #this command deploy the contracts
```

## Creating the javascript front-end with the template "pet-shop":
#### File : /src/js/app.js
1 - Function to get the contract and display it on the view
```javascript
  getMpData: function() {
    // This function get the data of the contract material Provider and display on the front end using jQuery
    
      App.contracts.MaterialProvider.deployed().then(function(instance) {
       ctMpInstance = instance;

       var addressMp = ctMpInstance.address
       
       $('#mp-address').val(addressMp);
      listDatas2 = []

      ctMpInstance.getData().then(function(datas2) {
        for (i = 0; i < datas2.length; i++) {
          listDatas2.push(datas2[i]['c'][0]);
        }

        var actual_steel_panel = listDatas2[0];
        var actual_rails = listDatas2[1];
        var actual_sensor = listDatas2[2];
        var actual_steel_sheet = listDatas2[3];
        var actual_pulley = listDatas2[4];
        var actual_motor = listDatas2[5];
        var actual_steelcable = listDatas2[6];
        var actual_ledlight = listDatas2[7];
        var actual_button = listDatas2[8];
        var actual_screen = listDatas2[9];
        var actual_controller = listDatas2[10];

        $('#steel_panel1').text(actual_steel_panel);
        $('#Rails1').text(actual_rails);
        $('#Sensor1').text(actual_sensor);
        $('#Steel_sheet1').text(actual_steel_sheet);
        $('#Pulley1').text(actual_pulley);
        $('#Motor1').text(actual_motor);
        $('#Steel_Cable1').text(actual_steelcable);
        $('#ledlight1').text(actual_ledlight);
        $('#Button1').text(actual_button);
        $('#Screen1').text(actual_screen);
        $('#Controller1').text(actual_controller);
      })
    })
  }
```

2 - Function to get the data of the first node using the address:
```javascript
getPoData: function(event) {
// This function get the data of the contract ProjectOffice and display on the front end using jQuery
    event.preventDefault();

    console.log("inside getPoData function");

    var po_address = $('#po-address').val();

    console.log(po_address);

    App.contracts.ProjectOffice.at(po_address).then(function(instance) {
      ctPoInstance = instance;
   
      listDatas = []

      ctPoInstance.getData().then(function(datas) {
        for (i = 0; i < datas.length; i++) {
          listDatas.push(datas[i]['c'][0]);
        }

        $('#controller').text(listDatas[0]);
        $('#cage').text(listDatas[1]);
        $('#motor').text(listDatas[2]);
        $('#door').text(listDatas[3]);
        $('#button').text(listDatas[4]);
        $('#display').text(listDatas[5]);

        
        var steel_panel = (listDatas[1] * 10 + listDatas[3] * 4);
        var rails = (listDatas[3] * 2);
        var sensor = (listDatas[3] * 4);
        var steel_sheet = (listDatas[1] * 10 + listDatas[3] * 4);
        var pulley = (listDatas[1] * 2);
        var motor = (listDatas[2]);
        var steelcable = (listDatas[1] * 50);
        var ledlight = (listDatas[1] * 4 + listDatas[4]);
        var button = (listDatas[4]);
        var screen = (listDatas[5]);
        var controller = (listDatas[0]);

        $('#steel_panel-mp').val(parseInt(steel_panel));
        $('#rails-mp').val(parseInt(rails));
        $('#sensor-mp').val(parseInt(sensor));
        $('#steel_sheet-mp').val(parseInt(steel_sheet));
        $('#pulley-mp').val(parseInt(pulley));
        $('#motor-mp').val(parseInt(motor));
        $('#steelcable-mp').val(parseInt(steelcable));
        $('#ledlight-mp').val(parseInt(ledlight));
        $('#button-mp').val(parseInt(button));
        $('#screen-mp').val(parseInt(screen));
        $('#controller-mp').val(parseInt(controller));
      })
    })

  }
```

3 - Function to submit the transaction 

```javascript
  submitContract: function(event) {
    // function for submit the transaction and modify the contract Material Provider
    event.preventDefault();
    
    // geting the value in the front end
    var steel_panel = parseInt($('#steel_panel-mp').val());
    var rails = parseInt($('#rails-mp').val());
    var sensor = parseInt($('#sensor-mp').val());
    var steel_sheet = parseInt($('#steel_sheet-mp').val());
    var pulley = parseInt($('#pulley-mp').val());
    var motor = parseInt($('#motor-mp').val());
    var steelcable = parseInt($('#steelcable-mp').val());
    var ledlight = parseInt($('#ledlight-mp').val());
    var button = parseInt($('#button-mp').val());
    var screen = parseInt($('#screen-mp').val());
    var controller = parseInt($('#controller-mp').val());

    var datas = [
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
    
    var contractInstance;
    
    //geting the account for the transaction 
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }   
      var account = accounts[0];

      // creating an intance of the contract MaterialProvider
      App.contracts.MaterialProvider.deployed().then(function(instance) {
        contractInstance = instance;
            
            //calling the metho setData of the contract and refresh the new data in the front end
            return contractInstance.setData(datas, {from: account});
          }).then(function(){App.init()}).catch(function(err) {
            console.log(err.message);
          });
        });
  },
```

4 - Function modified to init the new contracts
```javascript
initContract: function() {

    $.getJSON('MaterialProvider.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      var MaterialProviderArtifact = data;
      App.contracts.MaterialProvider = TruffleContract(MaterialProviderArtifact);
    
      // Set the provider for our contract
      App.contracts.MaterialProvider.setProvider(App.web3Provider);
      return App.getMpData();
    });

    $.getJSON('ProjectOffice.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      var ProjectOfficeArtifact = data;
      App.contracts.ProjectOffice = TruffleContract(ProjectOfficeArtifact);
    
      // Set the provider for our contract
      App.contracts.ProjectOffice.setProvider(App.web3Provider);
    
    });

    return App.bindEvents();
  }
```

## Creating html front-end:
#### File : /src/js/index.html

## Developpers
- Julien Dupont
- Kiefer Rivard
- Teddy Blanco
