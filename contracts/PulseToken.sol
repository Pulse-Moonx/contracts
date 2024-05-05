// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract PulseToken is ERC20, ERC20Permit {
    constructor()
        ERC20("Pulse Token", "PSTK")
        ERC20Permit("Pulse Token")
    {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
