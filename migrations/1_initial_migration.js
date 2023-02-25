const PixelDapp = artifacts.require("PixelDapp");

module.exports = function (deployer) {
  deployer.deploy(PixelDapp);
};
