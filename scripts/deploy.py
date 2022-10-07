##imports
from brownie import (
    accounts,
    config,
    network,
    Spice,
    SpiceLiquidityHandler,
    interface,
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import time

##Immutable Variables
OWNER_ADDRESS = "0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B"
BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
ROUTER = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"
##real busd "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
##----------------------objectives
charity = "0x2311f6e7E8550a867a0008830004B017B6fe6376"


def deploy_Contracts():
    ##set up
    account = get_account()
    spice = Spice.deploy(account, account, account, account, account, {"from": account})
    print("deployed spice successfully")


def latest_contract():
    return Spice[-1]


def test_swap():
    account = get_account()
    # arrange
    spice = Spice[-1]
    one_ether = Web3.toWei(1, "ether")
    ten_ether = Web3.toWei(120, "ether")
    tx = interface.IERC20(BUSD_ADDRESS).transfer(
        spice.address, ten_ether, {"from": account}
    )
    tx.wait(1)

    print(interface.IERC20(BUSD_ADDRESS).balanceOf(spice.address))
    print(interface.IERC20(spice.address).balanceOf(spice.address))
    tx1 = spice._addLiquidityBusd(
        ten_ether,
        ten_ether,
        {"from": account, "gas_limit": 2100000, "allow_revert": True},
    )
    tx1.wait(1)

    tx0 = spice.toggleFeeSwapping(True, {"from": account})
    tx0.wait(1)


def deploy_liquidity_handler():
    account = get_account()
    spice = Spice[-1]
    pair = spice.pairBusd()
    liquityM = SpiceLiquidityHandler.deploy(
        spice.address, BUSD_ADDRESS, ROUTER, pair, {"from": account}
    )


def set_fee_wallets():
    account = get_account()
    spice = Spice[-1]
    liquidity = SpiceLiquidityHandler[-1]
    tx = spice.setFeeReceivers(
        liquidity.address, account, charity, account, {"from": account}
    )
    tx.wait(1)


def set_fee_wallets():
    time.sleep(1)
    account = get_account()
    spice = Spice[-1]
    liquidity = SpiceLiquidityHandler[-1]
    tx = spice.setFeeReceivers(
        account, account, charity, liquidity.address, {"from": account}
    )
    tx.wait(1)


def main():
    deploy_Contracts()
    test_swap()
    deploy_liquidity_handler()
    set_fee_wallets()
