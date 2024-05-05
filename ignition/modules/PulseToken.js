const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");
require('dotenv').config();

module.exports = buildModule("PulseModule", (m) => {
  const owner = m.getParameter("initialOwner", process.env.PUBLIC_KEY_ADDRESS);

  const pulseToken = m.contract("PulseToken", [owner], {
    value: owner,
  });

  return { pulseToken };
});
