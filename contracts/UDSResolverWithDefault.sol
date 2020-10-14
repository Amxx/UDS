// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import './UDSResolverWithFallback.sol';

contract UDSResolverWithDefault is UDSResolverWithFallback, Ownable
{
    function setDefaultAddress(bytes32 key, address          value) external onlyOwner() { _setData(address(0), key, abi.encode(value)); }
    function setDefaultUint256(bytes32 key, uint256          value) external onlyOwner() { _setData(address(0), key, abi.encode(value)); }
    function setDefaultBytes32(bytes32 key, bytes32          value) external onlyOwner() { _setData(address(0), key, abi.encode(value)); }
    function setDefaultString (bytes32 key, string  calldata value) external onlyOwner() { _setData(address(0), key, bytes(value));      }
    function setDefaultBytes  (bytes32 key, bytes   calldata value) external onlyOwner() { _setData(address(0), key, bytes(value));      }
}
