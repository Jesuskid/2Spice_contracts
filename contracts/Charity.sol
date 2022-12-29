// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

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
        payable(msg.sender).transfer(msg.value);
    }

    receive() external payable {
        emit Log("fallback", msg.sender, msg.value, "");
        payable(msg.sender).transfer(msg.value);
    }

    function transferTo(address rec, uint256 amount) public onlyRole(DEV_ROLE) {
        uint256 balance = IERC20(busd).balanceOf(address(this));
        require(amount >= balance, "Withdraw amount exceeds balance");
        IERC20(busd).transfer(rec, amount);
    }
}
