##imports
from brownie import (
    accounts,
    config,
    network,
    Spice,
    interface,
)
from scripts.helpful_scripts import get_account
from web3 import Web3

##Immutable Variables
OWNER_ADDRESS = "0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B"
BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"

##real busd "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
##----------------------objectives


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
    ten_ether = Web3.toWei(11, "ether")
    # tx0 = interface.IERC20(spice.address).approve(account, ten_ether, {"from": account})
    # tx0.wait(1)
    tx = interface.IERC20(BUSD_ADDRESS).transfer(
        spice.address, ten_ether, {"from": account}
    )
    tx.wait(1)

    print(interface.IERC20(BUSD_ADDRESS).balanceOf(spice.address))
    print(interface.IERC20(spice.address).balanceOf(spice.address))
    # print(ten_ether)
    # print(spice.pairBusd())
    tx1 = spice._addLiquidityBusd(
        ten_ether,
        ten_ether,
        {"from": account, "gas_limit": 2100000, "allow_revert": True},
    )
    tx1.wait(1)

    # tx2 = spice._swapSpiceForBusd(
    #     one_ether,
    #     account,
    #     {"from": account, "gas_limit": 2100000},
    # )
    # tx2.wait(1)


def main():
    deploy_Contracts()
    test_swap()
