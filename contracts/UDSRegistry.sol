// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/GSN/Context.sol";

contract UDSRegistry is Context
{
    mapping(address => address) public resolver;

    event NewResolver(address indexed account, address resolver);

    function setResolver(address newResolver)
    external
    {
        address account = _msgSender();
        resolver[account] = newResolver;
        emit NewResolver(account, newResolver);
    }
}
