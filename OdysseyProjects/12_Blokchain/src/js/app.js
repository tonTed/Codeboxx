App = {
  web3Provider: null,
  contracts: {},

  init: async function() {

    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

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
  },

  bindEvents: function() {
    $(document).on('click', '.btn-mp', App.submitContract);
    //$(document).on('click', '.btn-mp', App.getMpData);
    $(document).on('click', '.btn-po', App.getPoData);
    //$(document).on('click', '.btn-po', App.getMpData);
  },

  submitContract: function(event) {
    // function for submit the transaction and modify the contract Material Provider
   
    event.preventDefault();
      
    console.log("inside materialProvider function");

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
  
  getPoData: function(event) {
    // This function get the data of the contract ProjectOffice and display on the front end using jQuery
    event.preventDefault();

    //geting the value of the address set in the form in the frontend
    var po_address = $('#po-address').val();

    console.log(po_address);

    // Creating an instance of the contract ProjectOffice with the address
    App.contracts.ProjectOffice.at(po_address).then(function(instance) {
      ctPoInstance = instance;

      listDatas = []

      // Geting the data of the contract
      ctPoInstance.getData().then(function(datas) {
        for (i = 0; i < datas.length; i++) {
          listDatas.push(datas[i]['c'][0]);
        }

        // Seting the values of the ProjectOffice in the front-end
        $('#controller').text(listDatas[0]);
        $('#cage').text(listDatas[1]);
        $('#motor').text(listDatas[2]);
        $('#door').text(listDatas[3]);
        $('#button').text(listDatas[4]);
        $('#display').text(listDatas[5]);

        // Compute and seting the value by default of Materials in the front end
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

  },

  getMpData: function(event) {
    // This function get the data of the contract material Provider and display on the front end using jQuery
    // This method is load when the windows is loaded in the function initContract

    //event.preventDefault();
    
    console.log("inside getTestData function");

    
      // Creating an instance of the contract
      App.contracts.MaterialProvider.deployed().then(function(instance) {
       ctMpInstance = instance;

       var addressMp = ctMpInstance.address
       
       $('#mp-address').val(addressMp);
      listDatas2 = []

      // Geting the data of the contract
      ctMpInstance.getData().then(function(datas2) {
        for (i = 0; i < datas2.length; i++) {
          console.log("ici!!!")
          console.log(datas2[i]['c'][0]);
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


        // Display the data in the front end
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
}

$(function() {
  $(window).load(function() {
    App.init();
  });
});
