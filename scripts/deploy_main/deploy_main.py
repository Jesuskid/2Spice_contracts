##deploys charity, treasury and devAndMarketing wallets
from brownie import (
    accounts,
    config,
    network,
    SpiceLiquidityHandler,
    Spice,
    interface,
    Charity,
    Dev,
    Treasury,
    Presale,
)
from scripts.helpful_scripts import get_account, BUSD_ADDRESS, ROUTER_ADDRESS, OWNER_ADDRESS
from web3 import Web3
import time


BUSD_ADDRESS = BUSD_ADDRESS
ACCOUNT = get_account()
ROUTER = ROUTER_ADDRESS
OWNER = OWNER_ADDRESS


# def deploy_presale():
#     account = get_account()
#     presale = Presale.deploy(Wallet, {"from": account})


def deploy_Contracts():
    account = get_account()
    presale_supply = Web3.toWei(10000, "ether")
    presale = Presale[-1]
    spice = Spice.deploy(
        BUSD_ADDRESS,
        presale.address,
        ROUTER,
        OWNER,
        {"from": account},
    )
    print("deployed spice successfully")


def setWallets():
    account = get_account()
    presale = Presale[-1]
    spice = Spice[-1]
    tx = presale.setTokenAddresses(spice.address, BUSD_ADDRESS, {"from": account})
    tx.wait(1)


def latest_contract():
    return Spice[-1]


def latest_presale():
    return Presale[-1]


def deploy_liquidity_handler():
    account = get_account()
    spice = Spice[-1]
    pair = spice.pairBusd()
    liquityM = SpiceLiquidityHandler.deploy(
        spice.address, BUSD_ADDRESS, ROUTER, pair, {"from": account}
    )


def set_fee_wallets():
    charity = Charity[-1]
    treasury = Treasury[-1]
    dev = Dev[-1]
    account = get_account()
    spice = Spice[-1]
    presale = Presale[-1]
    liquidity = SpiceLiquidityHandler[-1]
    tx = spice.setFeeReceivers(
        liquidity.address, treasury, charity, dev, {"from": account}
    )
    tx.wait(1)


def addTestLiqudity():
    account = get_account()
    spice = Spice[-1]

    one_ether = Web3.toWei(1, "ether")
    ten_ether = Web3.toWei(1000, "ether")

    print(spice.feeCollectedSpice())

    tx = interface.IERC20(BUSD_ADDRESS).transfer(
        spice.address, ten_ether, {"from": account}
    )
    tx.wait(1)

    tx2 = interface.IERC20(spice.address).transfer(
        spice.address, ten_ether, {"from": account}
    )
    tx2.wait(1)

    print(interface.IERC20(BUSD_ADDRESS).balanceOf(spice.address))
    print(interface.IERC20(spice.address).balanceOf(spice.address))

    tx1 = spice.addLiquidityBusd(
        ten_ether,
        ten_ether,
        {"from": account, "gas_limit": 2100000},
    )
    tx1.wait(1)

    tx0 = spice.toggleFeeSwapping(True, {"from": account})
    tx0.wait(1)


def main():
    deploy_Contracts()
    setWallets()
    deploy_liquidity_handler()
    set_fee_wallets()
    addTestLiqudity()
