// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import './UDSResolver.sol';

contract UDSResolverWithFallback is UDSResolver
{
    mapping(address => address) private delegation;

    event DelegationUpdated(address indexed account, address delegateTo);

    function setDelegation(address delegateTo)
    external
    {
        address account = _msgSender();
        delegation[account] = delegateTo;
        emit DelegationUpdated(account, delegateTo);
    }

    function getDelegation(address account)
    external view returns (address)
    {
        return delegation[account];
    }

    function _getData(address account, bytes32 key)
    internal virtual override view returns (bytes memory value)
    {
        value = super._getData(account, key);
        if (value.length == 0)
        {
            address delegateTo = delegation[account];
            // stop loops (particularly on address 0)
            if (delegateTo != account)
            {
                value = _getData(delegateTo, key);
            }
        }
    }
}
