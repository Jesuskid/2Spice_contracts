// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface ISpice {
    function addInitialLiquidity(uint256 tokenA, uint256 tokenB) external;
}

contract Presale is Ownable {
    //the presale functions to create new tokens

    address public SpiceAddress;
    address public busd;
    uint256 public presaleTimer;
    bool public presaleOpen = false;
    bool public presaleOver = false;
    bool public tokensSet = false;
    address presaleWithdrawWallet;
    uint256 public presalePrice = 1;

    constructor(address _withdrawWallet) {
        presaleWithdrawWallet = _withdrawWallet;
    }

    modifier checkPresaleOpen() {
        require(presaleOpen == true, "the presale has not yet open");
        _;
    }

    //sets the presale as open and sets timer
    function openPresale() external onlyOwner {
        require(presaleOpen == false, "presale is already open");
        presaleOpen = true;
        uint256 time = 1 weeks + block.timestamp;
        presaleTimer = time;
        emit PresaleOpened(time, msg.sender);
    }

    function setTokenAddresses(address _spiceAddress, address _busd)
        external
        onlyOwner
    {
        tokensSet = true;
        SpiceAddress = _spiceAddress;
        busd = _busd;
    }

    //presale function mints new tokens in exchange for busd

    function presale(uint256 busdAmount) external checkPresaleOpen {
        uint256 spiceBalance = IERC20(SpiceAddress).balanceOf(address(this));
        require(busdAmount > 0, "amount must be greater than zero"); //busd amount must be greater than zero
        require(block.timestamp <= presaleTimer, "presale has ended");
        require(spiceBalance >= busdAmount, "Presale is sold out");
        uint256 spiceAmount = busdAmount;
        IERC20(busd).transferFrom(msg.sender, address(this), busdAmount);
        IERC20(SpiceAddress).transfer(msg.sender, spiceAmount);
    }

    //withdraw presale funds to presale wallet
    function openContractAndWithdrawPresale() public onlyOwner {
        require(presaleOpen == true, "presale is not yet open");
        require(block.timestamp > presaleTimer, "presale is not over yet");
        presaleOpen = false;
        presaleOver = true;
        uint256 busdBalance = IERC20(busd).balanceOf(address(this));
        uint256 amountToPCS = (60 * busdBalance) / 100;
        uint256 remainder = busdBalance - amountToPCS;
        IERC20(busd).transfer(SpiceAddress, amountToPCS);
        ISpice(SpiceAddress).addInitialLiquidity(amountToPCS, amountToPCS);
        IERC20(busd).transfer(presaleWithdrawWallet, remainder);
        emit PresaleWithdrawn(presaleWithdrawWallet, remainder);
    }

    event PresaleWithdrawn(address wallet, uint256 busdBalance);
    event PresaleOpened(uint256 time, address sender);
}
