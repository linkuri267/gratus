module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
   development: {
   host: "localhost",
   port: 8545,
   network_id: "*", // Match any network id
   gas: 4600000,
   from: "0x4470786Ce32D9362A56dc0D63E2c1296DeE0013B"

  }
 }
};
