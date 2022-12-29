from brownie import (
    accounts,
    config,
    network,
    Spice,
    interface,
    Contract,
    SpiceLiquidityHandler,
    GameReward,
)
from brownie.network import priority_fee
from scripts.helpful_scripts import get_account, get_account2
from web3 import Web3
import time
import datetime
import calendar

##Immutable Variables
C_ADDRESS = Spice[-1]
BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
router = interface.IPancakeRouter02("0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3")
router_address = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"


def first():
    account = get_account()
    print(account)
    weth = router.WETH.call()
    print(weth)
    path = [BUSD_ADDRESS, C_ADDRESS.address]

    path2 = [C_ADDRESS.address, BUSD_ADDRESS]
    one_ether = Web3.toWei(5, "ether")
    two_ether = Web3.toWei(5, "ether")

    
    feeCollectedB = C_ADDRESS.feeCollectedSpice()

    future = datetime.datetime.utcnow() + datetime.timedelta(minutes=5)
    now = calendar.timegm(future.timetuple())

    tx0 = C_ADDRESS.approve(
        router_address, two_ether, {"from": account, "gas_limit": 2100000}
    )
    tx0.wait(1)

    # tx01 = interface.IERC20(BUSD_ADDRESS).approve(
    #     router_address, two_ether, {"from": account, "gas_limit": 2100000}
    # )
    # tx01.wait(1)

    print('swapping Busd for Spcie')
    tx2 = router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
        two_ether, 0, path, account, now, {"from": account, "gas_limit": 2100000}
    )
    tx2.wait(1)
    balance = C_ADDRESS.balanceOf(account)
    print(balance)

    # print('swapping Spice for BUSD')
    # tx3 = router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
    #     one_ether, 0, path2, account, now, {"from": account, "gas_limit": 2100000}
    # )
    # tx3.wait(1)

    feeCollected = C_ADDRESS.feeCollectedSpice()
    canSwap = C_ADDRESS.canSwapFees(feeCollected)
    print(f"can swap {canSwap}")
    print("swap successful")
    print(f"fee collected spice {feeCollectedB,feeCollected}")

    spAfter = C_ADDRESS.balanceOf.call(C_ADDRESS.address)

    # print(tx2)
    # print(Web3.fromWei(spBefore, "ether"), Web3.fromWei(spAfter, "ether"))


def second():
    pathL = [C_ADDRESS.address, BUSD_ADDRESS]
    one_ether = Web3.toWei(0.1, "ether")
    future = datetime.datetime.utcnow() + datetime.timedelta(minutes=5)
    now = calendar.timegm(future.timetuple())
    account = get_account()
    spice = Spice[-1]

    lp = SpiceLiquidityHandler[-1]

    allowance = interface.IERC20(BUSD_ADDRESS).allowance(lp.address, router_address)

    print(spice.checkFeeExempt(lp.address), allowance)
    tx1 = lp._swapBusdForSpice(
        one_ether,
        account,
        {"from": account, "gas_limit": 2100000},
    )
    tx1.wait(1)


def evolve():
    pathL = [C_ADDRESS.address, BUSD_ADDRESS]
    one_ether = Web3.toWei(0.1, "ether")
    future = datetime.datetime.utcnow() + datetime.timedelta(minutes=5)
    now = calendar.timegm(future.timetuple())
    account = get_account()

    lp = SpiceLiquidityHandler[-1]

    tx1 = lp.swapAndEvolve(
        {"from": account, "gas_limit": 2100000},
    )
    tx1.wait(1)
    print("evolution")


def third():
    one_ether = Web3.toWei(1, "ether")
    two_ether = Web3.toWei(10, "ether")
    future = datetime.datetime.utcnow() + datetime.timedelta(minutes=5)
    now = calendar.timegm(future.timetuple())
    account = get_account()
    spice = Spice[-1]

    lp = SpiceLiquidityHandler[-1]
    rwd = GameReward[-1]

    tx00 = C_ADDRESS.approve(
        rwd.address, two_ether, {"from": account, "gas_limit": 2100000}
    )
    tx00.wait(1)

    tx1 = rwd.deposit(one_ether, "email", {"from": account, "gas_limit": 2100000})
    tx1.wait(1)

    print(C_ADDRESS.balanceOf(rwd.address))

    tx2 = rwd.adminWithdrawFor(
        one_ether,
        "email",
        "0x1032a3611DFF46cA46e744A064291cBb3dD65a0d",
        {"from": account, "gas_limit": 2100000},
    )
    tx2.wait(1)

    allowance = interface.IERC20(BUSD_ADDRESS).allowance(lp.address, router_address)


def transfer():
    account = get_account()
    spice = Spice[-1]
    account2 =get_account2()

    one_ether = Web3.toWei(1, "ether")
    ten_ether = Web3.toWei(200, "ether")

    print(spice.feeCollectedSpice())

    tx2 = interface.IERC20(spice.address).transfer(
        account2, ten_ether, {"from": account}
    )
    tx2.wait(1)


def fetchPCS():
    spice = Spice[-1]
    var = spice.fetchPCSPrice()

    print(var)


def main():
    # transfer()
    first()
