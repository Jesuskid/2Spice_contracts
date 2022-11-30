// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(
            c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256),
            "mul: invalid with MIN_INT256"
        );
        require((b == 0) || (c / b == a), "mul: combi values invalid");
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256, "div: b == 1 or a == MIN_INT256");
        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require(
            (b >= 0 && c <= a) || (b < 0 && c > a),
            "sub: combi values invalid"
        );
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require(
            (b >= 0 && c >= a) || (b < 0 && c < a),
            "add: combi values invalid"
        );
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256, "abs: a equal MIN INT256");
        return a < 0 ? -a : a;
    }
}

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

interface IPancakeFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface InterfaceLP {
    function sync() external;
}

interface ILiquidityManager {
    function swapAndEvolve() external;
}

contract Spice is ERC20, ERC20Burnable, Ownable {
    using SafeMathInt for int256;
    using SafeMath for uint256;

    IPancakeRouter02 private router;

    address public busd;
    address public liquidityReceiver;
    address public pairBusd;

    address public devAndMarketingWallet;
    address public treasuryWallet;
    address public charityWallet;
    address public liqudityHandlerWallet;

    address presaleWithdrawWallet;

    mapping(address => uint256) private _balances;
    mapping(address => bool) _isFeeExempt;
    mapping(address => bool) marketPairs;
    mapping(address => mapping(address => uint256)) private _allowedFragments;
    address[] _markerPairs;
    address[] path = [busd, address(this)];

    uint256 private _totalSupply;

    uint256 initialSupply = 1000e18; //check for deploy var
    uint256 public presalePrice = 1;
    uint256 public presaleTimer;
    uint256 public feeCollectedSpice;
    uint256 public feeCollectedBusd;
    uint256 stuckFees;
    uint256 SWAP_TRESHOLD = 50000000;

    // fees
    uint256 public totalBuyFee = 5;
    uint256 public totalSellFee = 10;
    uint256 buyLP = 3;
    uint256 buyTreasury = 2;

    uint256 sellDevMarketing = 2;
    uint256 sellLP = 3;
    uint256 sellTreasury = 3;
    uint256 sellCharity = 2;

    uint256 MaxPoolBurn = 10000e18;

    uint256 internalPoolBusdReserves;

    bool public presaleOpen = false;
    bool public presaleOver = false;
    bool swapEnabled = false;
    bool private inSwap;
    address presaleContract;

    modifier swapping() {
        require(inSwap == false, "ReentrancyGuard: reentrant call");
        inSwap = true;
        _;
        inSwap = false;
    }

    modifier isReadyForTrade() {
        require(presaleOver == true, "the presale has not yet ended");
        _;
    }

    bool evolutionEnabled = true;

    constructor(
        address _busd,
        address _presaleContract,
        address _router,
        uint256 _presaleSupply
    )
        //busd address,
        ERC20("F2Spice", "FSpice")
        ERC20Burnable()
    {
        busd = _busd;
        router = IPancakeRouter02(_router);

        pairBusd = IPancakeFactory(router.factory()).createPair(
            address(this),
            busd
        );

        address routerAddress = _router;
        _markerPairs.push(pairBusd);
        marketPairs[pairBusd] = true;

        IERC20(busd).approve(routerAddress, type(uint256).max);
        IERC20(busd).approve(address(pairBusd), type(uint256).max);
        IERC20(busd).approve(address(this), type(uint256).max);

        _allowedFragments[address(this)][address(router)] = type(uint256).max;
        _allowedFragments[address(this)][address(this)] = type(uint256).max;
        _allowedFragments[address(this)][pairBusd] = type(uint256).max;

        _isFeeExempt[address(this)] = true;

        _isFeeExempt[msg.sender] = true;
        _isFeeExempt[_presaleContract] = true;

        presaleContract = _presaleContract;
        //test mints
        _mint(msg.sender, initialSupply);
        _mint(_presaleContract, initialSupply);
    }

    //Internal pool sell to function, takes fees in BUSD
    function sellToThis(uint256 spiceAmount) external {
        require(spiceAmount > 0);
        //gets the spice price
        uint256 spicePrice = fetchPCSPrice();
        uint256 busdAmountBeforeFees = (spiceAmount * spicePrice) / 1e18;
        uint256 IP_BUSD_Balance = IERC20(busd).balanceOf(address(this));
        require(
            busdAmountBeforeFees <= IP_BUSD_Balance,
            "insufficient liquidity in the internal pool"
        );
        //fees
        uint256 fee = (busdAmountBeforeFees * totalSellFee) / 100;
        feeCollectedBusd += fee;
        //amount after fees
        uint256 sellAmount = busdAmountBeforeFees - fee;

        //burns all spice sent to contract
        _balances[msg.sender] -= spiceAmount;
        _totalSupply -= spiceAmount;
        internalPoolBusdReserves -= busdAmountBeforeFees;

        ILPTransferFees(false, busdAmountBeforeFees);
        IERC20(busd).transfer(msg.sender, sellAmount);

        emit Transfer(msg.sender, address(0), spiceAmount);
    }

    //Internal pool buy from function, takes fees in BUSD
    function purchaseFromThis(uint256 busdAmount) external {
        require(busdAmount > 0);
        //fetch spice price
        uint256 spicePrice = fetchPCSPrice();
        // get fees
        uint256 fee = (busdAmount * totalBuyFee) / 100;
        feeCollectedBusd += fee;
        //busd received
        uint256 busdReceived = busdAmount - fee;
        //send busd yo contract with fees
        uint256 spiceAmount = (busdReceived * 1e18) / spicePrice;
        IERC20(busd).transferFrom(msg.sender, address(this), busdAmount);
        ILPTransferFees(true, busdAmount);
        //mint token to sender's balances
        _mint(msg.sender, spiceAmount);
        internalPoolBusdReserves += busdReceived;
    }

    //helper function that allows the contract to swap with PCS pool
    function _swapSpiceForBusd(uint256 tokenAmount, address receiver) private {
        uint256 deadline = block.timestamp + 1 minutes;
        address[] memory cvxPath = new address[](2);
        cvxPath[0] = address(this);
        cvxPath[1] = busd;
        router.swapExactTokensForTokens(
            tokenAmount,
            0,
            cvxPath,
            receiver,
            deadline
        );
    }

    //check
    //set accounts that are exempt from fees
    function setFeeExempt(address _addr, bool _value) external onlyOwner {
        require(_isFeeExempt[_addr] != _value, "Not changed");
        _isFeeExempt[_addr] = _value;
        emit SetFeeExempted(_addr, _value);
    }

    function setPresaleWallet(address _presaleC) external onlyOwner {
        presaleContract = _presaleC;
    }

    //ERC20 overidden functions

    //check
    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowanceForUser(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _spendAllowanceForUser(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = _allowedFragments[owner][spender];
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);
        uint256 feesCollected = feeCollectedSpice;

        if (
            canSwapFees(feesCollected) &&
            !marketPairs[from] &&
            !inSwap &&
            !_isFeeExempt[from]
        ) {
            inSwap = true;
            swapAndTransferFees(feesCollected);
            inSwap = false;
        }

        if (canEvolve(from)) {
            inSwap = true;
            ILiquidityManager(liqudityHandlerWallet).swapAndEvolve();
            inSwap = false;
        }

        uint256 fromBalance = _balances[from];

        require(
            fromBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        uint256 amountReceived = _shouldTakeFee(from, to)
            ? takeFees(from, to, amount)
            : amount;

        unchecked {
            _balances[from] = fromBalance.sub(amount);
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amountReceived;
        }

        emit Transfer(from, to, amountReceived);

        _afterTokenTransfer(from, to, amountReceived);
    }

    //check
    //set take fee amount returns amount minus fees
    function takeFees(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (uint256) {
        uint256 _realFee = 0;
        bool isBuy;
        //determine the fee
        if (marketPairs[recipient]) _realFee = totalSellFee;
        if (marketPairs[sender]) _realFee = totalBuyFee;

        _realFee = (_realFee * amount) / 100;
        uint256 gonAmount = amount.sub(_realFee);
        uint256 feeAmount = amount - gonAmount;
        _balances[address(this)] = _balances[address(this)] += feeAmount;
        feeCollectedSpice += feeAmount;

        emit Transfer(sender, address(this), feeAmount);
        //return fee
        return gonAmount;
    }

    //check
    function _shouldTakeFee(address from, address to)
        private
        view
        returns (bool isExempt)
    {
        if (_isFeeExempt[from] || _isFeeExempt[to]) {
            return false;
        } else if (marketPairs[from] || marketPairs[to]) {
            return true;
        } else {
            return false;
        }
    }

    //check
    //allows the contract to add liquidity
    function addLiquidityBusd(uint256 tokenAmount, uint256 busdAmount) public {
        router.addLiquidity(
            address(this),
            busd,
            tokenAmount,
            busdAmount,
            0,
            0,
            liqudityHandlerWallet,
            block.timestamp
        );
    }

    function addInitialLiquidity(uint256 tokenA, uint256 tokenB) external {
        require(msg.sender == presaleContract);
        require(tokenA == tokenB, "amount not equal");
        _mint(address(this), tokenB);
        addLiquidityBusd(tokenA, tokenB);
    }

    function manualSync() public {
        for (uint256 i = 0; i < _markerPairs.length; i++) {
            InterfaceLP(_markerPairs[i]).sync();
        }
    }

    function canSwapFees(uint256 _fee) public view returns (bool canswap) {
        uint256 pairBalance = IERC20(busd).balanceOf(pairBusd);
        if (pairBalance > (_fee.mul(2)) && _fee > 0 && swapEnabled == true) {
            return true;
        } else {
            return false;
        }
    }

    function canEvolve(address _from) public view returns (bool evolve) {
        uint256 liqudityHandlerWalletBusdBalance = IERC20(busd).balanceOf(
            liqudityHandlerWallet
        );
        if (
            liqudityHandlerWalletBusdBalance > SWAP_TRESHOLD &&
            !_isFeeExempt[_from] &&
            inSwap == false &&
            !marketPairs[_from] &&
            evolutionEnabled == true
        ) {
            return true;
        } else {
            return false;
        }
    }

    function toggleFeeSwapping(bool isEnabled) public onlyOwner {
        swapEnabled = isEnabled;
        emit SwappingStateChanged(isEnabled);
    }

    function toggleEvolution(bool isEnabled) public onlyOwner {
        evolutionEnabled = isEnabled;
        emit SwappingStateChanged(isEnabled);
    }

    //distributes fess
    function swapAndTransferFees(uint256 _fee) public {
        uint256 totalFee = totalSellFee + totalBuyFee; //gas savings
        uint256 amountToTreasury = (_fee *
            ((sellTreasury.add(buyTreasury) * 100) / totalFee)) / 100;
        uint256 amountToLP = (_fee * ((sellLP.add(buyLP) * 100) / totalFee)) /
            100;
        uint256 amountToMarketing = (_fee *
            ((sellDevMarketing * 100) / totalFee)) / 100;
        uint256 amountToCharity = (_fee * ((sellCharity * 100) / totalFee)) /
            100;
        _swapSpiceForBusd(amountToTreasury, treasuryWallet);
        _swapSpiceForBusd(amountToLP, liqudityHandlerWallet);
        _swapSpiceForBusd(amountToMarketing, devAndMarketingWallet);
        _swapSpiceForBusd(amountToCharity, charityWallet);
        feeCollectedSpice -=
            amountToTreasury +
            amountToMarketing +
            amountToLP +
            amountToCharity;
    }

    //transfers busd fees collected
    function ILPTransferFees(bool isBuy, uint256 _fee) public {
        if (isBuy == true) {
            uint256 amountToTreasury = (buyTreasury * _fee) / 100;
            uint256 amountToLP = (buyLP * _fee) / 100;

            IERC20(busd).transfer(treasuryWallet, amountToTreasury);

            _mint(address(this), amountToLP);
            addLiquidityBusd(amountToLP, amountToLP);
        } else if (isBuy == false) {
            uint256 amountToTreasury = (sellTreasury * _fee) / 100;
            uint256 amountToLP = (sellLP * _fee) / 100;
            uint256 amountToMarketing = (sellDevMarketing * _fee) / 100;
            uint256 amountToCharity = (sellCharity * _fee) / 100;
            IERC20(busd).transfer(treasuryWallet, amountToTreasury);
            IERC20(busd).transfer(devAndMarketingWallet, amountToMarketing);
            IERC20(busd).transfer(charityWallet, amountToCharity);
            _mint(address(this), amountToLP);
            addLiquidityBusd(amountToLP, amountToLP);
        }
    }

    //setter functions
    //check
    function setNewMarketMakerPair(address _pair, bool _value)
        public
        onlyOwner
    {
        require(marketPairs[_pair] != _value, "Value already set");

        marketPairs[_pair] = _value;
        _markerPairs.push(_pair);
    }

    //check
    //Erc20 function overrides
    function balanceOf(address who) public view override returns (uint256) {
        return _balances[who];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual override {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowedFragments[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowedFragments[owner][spender];
    }

    //check
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function _mint(address account, uint256 amount) internal virtual override {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        override
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.sub(
                subtractedValue
            );
        }
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        override
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][
            spender
        ].add(addedValue);
        emit Approval(
            msg.sender,
            spender,
            _allowedFragments[msg.sender][spender]
        );
        return true;
    }

    //check
    function checkFeeExempt(address _addr) external view returns (bool) {
        return _isFeeExempt[_addr];
    }

    //check
    function clearStuckFees(address _receiver) external onlyOwner {
        uint256 balance = feeCollectedSpice; //gas optimization
        transfer(_receiver, balance);
        feeCollectedSpice = 0;
        emit ClearStuckBalance(_receiver);
    }

    //check
    //burn from the Pancake swap pair
    function burnFromPool(address holder, uint256 amount) public onlyOwner {
        uint256 poolBalance = balanceOf(pairBusd);
        require((poolBalance - MaxPoolBurn) > amount);
        _burnInternal(holder, amount);
    }

    //check
    function _burnInternal(address holder, uint256 amount) internal {
        require(marketPairs[holder], "It must be a pair contract");
        _totalSupply -= amount;
        _balances[holder] -= amount;
        InterfaceLP(holder).sync();
        emit Transfer(holder, address(0), amount);
    }

    function fetchPCSPrice() public view returns (uint256) {
        address[] memory cvxPath = new address[](2);
        cvxPath[0] = address(this);
        cvxPath[1] = busd;
        uint256[] memory out = router.getAmountsOut(1 ether, cvxPath);
        return out[1];
    }

    function _calcPCSPrice() public view returns (uint256) {
        uint256 spiceBalance = balanceOf(pairBusd);
        uint256 busdBalance = IERC20(busd).balanceOf(pairBusd);
        if (spiceBalance > 0) {
            uint256 price = busdBalance / spiceBalance;
            return price;
        } else {
            return 1;
        }
    }

    function changeSwapTreshold(uint256 newSwapTreshold) external onlyOwner {
        require(newSwapTreshold >= 1e18, "treshold must be higher");
        SWAP_TRESHOLD = newSwapTreshold;
    }

    //set fee wallets:
    function setFeeReceivers(
        address _liquidityReceiver,
        address _treasuryReceiver,
        address _charityValueReceiver,
        address _devAndMarketing
    ) external onlyOwner {
        liqudityHandlerWallet = _liquidityReceiver;
        treasuryWallet = _treasuryReceiver;
        charityWallet = _charityValueReceiver;
        devAndMarketingWallet = _devAndMarketing;
        _isFeeExempt[liqudityHandlerWallet] = true;
        _isFeeExempt[treasuryWallet] = true;
        _isFeeExempt[charityWallet] = true;
        _isFeeExempt[devAndMarketingWallet] = true;
        emit SetFeeReceivers(
            _liquidityReceiver,
            _treasuryReceiver,
            _charityValueReceiver,
            _devAndMarketing
        );
    }

    //events
    event SetFeeExempted(address _addr, bool _value);
    event BurnPCS(uint256 time, uint256 amount);
    event WalletTransfers(uint256 time, uint256 amount);
    event NewMarketMakerPair(address _pair, uint256 time);
    event PresaleWithdrawn(address receiver, uint256 amount);
    event PresaleOver(bool _over);
    event PresaleOpened(uint256 time, address sender);
    event SetFeeReceivers(
        address _liquidityReceiver,
        address _treasuryReceiver,
        address _riskFreeValueReceiver,
        address _marketing
    );
    event SwapBack(
        uint256 contractTokenBalance,
        uint256 amountToLiquify,
        uint256 amountToRFV,
        uint256 amountToDevMarketing,
        uint256 amountToTreasury,
        bool buy
    );
    event ClearStuckBalance(address _receiver);
    event SwappingStateChanged(bool enabled);
}
