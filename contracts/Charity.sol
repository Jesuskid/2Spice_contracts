// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Charity is AccessControl {
    bytes32 public constant DEV_ROLE = keccak256("DEV_ROLE");
    address internal busd;
    event Log(string func, address sender, uint256 value, bytes data);

    constructor(address _busd, address admin) {
        busd = _busd;
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setupRole(DEV_ROLE, admin);
    }

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("fallback", msg.sender, msg.value, "");
    }

    function transferTo(address rec, uint256 amount) public onlyRole(DEV_ROLE) {
        IERC20(busd).transfer(rec, amount);
    }
}
