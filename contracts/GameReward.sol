// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

//add access control to this contract

interface IPancakeRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

// File: contracts\interfaces\IPancakeRouter02.sol

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

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
    uint256 dId;
    uint256 wId;

    IPancakeRouter02 router;
    address busd;

    constructor(
        address _spiceContract,
        address _router,
        address _busd
    ) {
        admins[msg.sender] = true;
        spiceContract = _spiceContract;
        router = IPancakeRouter02(_router);
        busd = _busd;

        IERC20(spiceContract).approve(_router, type(uint256).max);
        IERC20(busd).approve(_router, type(uint256).max);
    }

    modifier canWithdraw() {
        require(admins[msg.sender], "Action prohitibited");
        _;
    }

    function setNewAdmin(address _newAdmin) public onlyOwner {
        admins[_newAdmin] = true;
    }

    function revokeAdmin(address _admin) public onlyOwner {
        require(_admin != owner(), "default admin cannot be revoked");
        admins[_admin] = false;
    }

    function updateFees(uint256 newFees) public onlyOwner {
        withdrawalFees = newFees;
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
        address ownerAddress = owner();
        uint256 c_balance = IERC20(spiceContract).balanceOf(address(this));
        require(
            receiver != ownerAddress,
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
            _swapFees(totalWithdrawFees, ownerAddress);
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

    function _swapFees(uint256 tokenAmount, address receiver) private {
        require(admins[receiver], "You cannot withdraw fees for this address");
        address[] memory path = new address[](2);
        path[0] = spiceContract;
        path[1] = busd;

        address[] memory path2 = new address[](3);
        path2[0] = spiceContract;
        path2[1] = busd;
        path2[2] = router.WETH();

        uint256 spiceBalance = IERC20(spiceContract).balanceOf(address(this));
        if (spiceBalance > withdrawalFees) {
            router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                tokenAmount,
                0,
                path,
                receiver,
                block.timestamp
            );
        }

        uint256 busdBalance = IERC20(busd).balanceOf(address(this));

        if (busdBalance > 0) {
            //set up for live deploys
            // router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            //     busdBalance,
            //     0,
            //     path2,
            //     receiver,
            //     block.timestamp
            // );
        }
    }
}
