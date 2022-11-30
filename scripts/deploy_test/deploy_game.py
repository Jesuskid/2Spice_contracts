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
    GameReward,
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import time

BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
ACCOUNT = get_account()
spice = Spice[-1]
router = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"


def main():
    tx = GameReward.deploy(spice.address, router, BUSD_ADDRESS, {"from": ACCOUNT})
