// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

//add access control to this contract

contract GameReward is Ownable, ReentrancyGuard {
    bytes32 public constant CAN_MAKE_WITHDRAWAL =
        keccak256("CAN_MAKE_WITHDRAWAL");
    mapping(address => uint256) balances;
    mapping(address => bool) depositor;
    mapping(address => uint256) _withdrawLimit;
    mapping(address => bool) public admins;
    uint256 totalRewardsBalance;
    uint256 withdrawalFees = 15000000000000000;
    uint256 totalWithdrawFees;
    address spiceContract;

    event Deposit(
        uint256 tID,
        uint256 time,
        string email,
        address despositor,
        uint256 amount
    );
    event Withdraw(
        uint256 tID,
        uint256 time,
        string email,
        address withdrawer,
        uint256 amount,
        address to
    );

    event FeesChange(uint256 newFess, address changedBy, uint256 timestamp);

    event NewAdmin(address newAdmin, uint256 timestamp);

    event RevokedAdmin(address revokedAdmin, uint256 timestamp);

    uint256 dId;
    uint256 wId;

    constructor(address _spiceContract, address defaultAdmin) {
        admins[defaultAdmin] = true;
        spiceContract = _spiceContract;
    }

    modifier canWithdraw() {
        require(admins[msg.sender], "Action prohitibited");
        _;
    }

    function setNewAdmin(address _newAdmin) public onlyOwner {
        admins[_newAdmin] = true;
        emit NewAdmin(_newAdmin, block.timestamp);
    }

    function revokeAdmin(address _admin) public onlyOwner {
        require(_admin != owner(), "default admin cannot be revoked");
        admins[_admin] = false;
        emit RevokedAdmin(_admin, block.timestamp);
    }

    function updateFees(uint256 newFees) public onlyOwner {
        withdrawalFees = newFees;
        emit FeesChange(newFees, msg.sender, block.timestamp);
    }

    function deposit(uint256 _spice, string memory email) public nonReentrant {
        dId = dId + 1;
        uint256 newId = dId;
        uint256 transaction_id = uint256(
            keccak256(abi.encode(newId, block.timestamp))
        ) % 10;
        totalRewardsBalance += _spice;
        IERC20(spiceContract).transferFrom(msg.sender, address(this), _spice);
        depositor[msg.sender] = true;
        balances[msg.sender] += _spice;

        emit Deposit(
            transaction_id,
            block.timestamp,
            email,
            msg.sender,
            _spice
        );
    }

    function adminWithdrawFor(
        uint256 _gems,
        string memory email,
        address receiver
    ) public canWithdraw {
        address owner = owner();
        uint256 c_balance = IERC20(spiceContract).balanceOf(address(this));
        require(
            receiver != owner,
            "owner cannot withdraw fee funds from the contract"
        );
        require(_gems > withdrawalFees, "not enough to withdraw");
        require(c_balance >= _gems, "inadequate gem balance");
        wId = wId + 1;
        uint256 newId = wId;
        uint256 transaction_id = uint256(
            keccak256(abi.encode(newId, block.timestamp))
        ) % 10;

        //takes two percent of the withdrawal fees to boost the reward contract balance
        uint256 boostRewardBalancePerecent = (withdrawalFees * 2) / 100;

        totalRewardsBalance -= (_gems - boostRewardBalancePerecent);

        //amount to be sent to receiver
        uint256 totalAmount = _gems - withdrawalFees;

        //fees save as contract balance
        totalWithdrawFees += withdrawalFees - boostRewardBalancePerecent;

        IERC20(spiceContract).transfer(receiver, totalAmount);
        if (totalWithdrawFees >= withdrawalFees) {
            address ownerAddress = msg.sender;
            IERC20(spiceContract).transfer(ownerAddress, totalWithdrawFees);
        }
        emit Withdraw(
            transaction_id,
            block.timestamp,
            email,
            msg.sender,
            _gems,
            receiver
        );
    }
}
