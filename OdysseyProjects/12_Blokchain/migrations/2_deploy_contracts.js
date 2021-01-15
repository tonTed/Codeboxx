var MaterialProvider = artifacts.require("MaterialProvider");
// Contract ProjectOffice for first node simulation
var ProjectOffice = artifacts.require("ProjectOffice");

module.exports = function(deployer) {
  deployer.deploy(MaterialProvider);
  deployer.deploy(ProjectOffice);
};