##deploys charity, treasury and devAndMarketing wallets
from brownie import (
    SpiceLiquidityHandler,
    Spice,
    interface,
    Charity,
    Dev,
    Treasury,
    Presale,
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import time

BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
ACCOUNT = get_account()
ROUTER = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"
Wallet = "0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B"
OWNER = get_account()


# def deploy_presale():
#     account = get_account()
#     presale = Presale.deploy(Wallet, {"from": account})


def buySell():
    account = get_account()
    spice = Spice[-1]

    one_ether = Web3.toWei(1, "ether")
    ten_ether = Web3.toWei(10, "ether")

    tx = interface.IERC20(BUSD_ADDRESS).approve(
        spice, ten_ether, {"from": account}
    )
    tx.wait(1)

    # tx2 = interface.IERC20(spice.address).approve(
    #     spice, ten_ether, {"from": account}
    # )
    # tx2.wait(1)


    tx3 = spice.purchaseFromThis(ten_ether, {'from': account})
    tx3.wait(1)


def main():
    buySell()