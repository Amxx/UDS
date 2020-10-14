// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import '@openzeppelin/contracts/GSN/Context.sol';

contract UDSResolver is Context
{
    mapping(address => mapping(bytes32 => bytes)) private store;

    event ValueUpdated(address indexed account, bytes32 indexed key);

    function setAddress(bytes32 key,     address          value) external                              { _setData(_msgSender(), key, abi.encode(value)); }
    function setUint256(bytes32 key,     uint256          value) external                              { _setData(_msgSender(), key, abi.encode(value)); }
    function setBytes32(bytes32 key,     bytes32          value) external                              { _setData(_msgSender(), key, abi.encode(value)); }
    function setString (bytes32 key,     string  calldata value) external                              { _setData(_msgSender(), key, bytes(value));      }
    function setBytes  (bytes32 key,     bytes   calldata value) external                              { _setData(_msgSender(), key, bytes(value));      }
    function getAddress(address account, bytes32          key  ) external view returns (address)       { return abi.decode(_getData(account, key), (address)); }
    function getUint256(address account, bytes32          key  ) external view returns (uint256)       { return abi.decode(_getData(account, key), (uint256)); }
    function getBytes32(address account, bytes32          key  ) external view returns (bytes32)       { return abi.decode(_getData(account, key), (bytes32)); }
    function getString (address account, bytes32          key  ) external view returns (string memory) { return string    (_getData(account, key));            }
    function getBytes  (address account, bytes32          key  ) external view returns (bytes  memory) { return bytes     (_getData(account, key));            }

    function _setData(address account, bytes32 key, bytes memory data)
    internal virtual
    {
        store[account][key] = data;
        emit ValueUpdated(account, key);
    }

    function _getData(address account, bytes32 key)
    internal virtual view returns (bytes memory)
    {
        return store[account][key];
    }
}
