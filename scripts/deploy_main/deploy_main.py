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
from scripts.helpful_scripts import get_account, BUSD_ADDRESS, ROUTER_ADDRESS, OWNER_ADDRESS
from web3 import Web3
import time


BUSD_ADDRESS = BUSD_ADDRESS
ACCOUNT = get_account()
ROUTER = ROUTER_ADDRESS
OWNER = OWNER_ADDRESS




def deploy_Contracts():
    account = get_account()
    spice = Spice.deploy(
        BUSD_ADDRESS,
        ROUTER,
        OWNER,
        {"from": account},
    )
    print("deployed spice successfully")





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
    liquidity = SpiceLiquidityHandler[-1]
    tx = spice.setFeeReceivers(
        liquidity.address, treasury, charity, dev, {"from": account}
    )
    tx.wait(1)

def feeCollected():
    spice = Spice[-1]
    feeCollectedB = spice.feeCollectedSpice()
    pair = spice.pairBusd()
    treasury = Treasury[-1]
    print(feeCollectedB)
    print(treasury)
    print(pair)


    
def main():
    # deploy_Contracts()
    # deploy_liquidity_handler()
    # set_fee_wallets()
    feeCollected()s