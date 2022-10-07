##deploys charity, treasury and devAndMarketing wallets
from brownie import (
    accounts,
    config,
    network,
    Spice,
    interface,
    Charity,
    Dev,
    Treasury,
    Presale,
)
from scripts.helpful_scripts import get_account
from web3 import Web3

BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
ACCOUNT = get_account()


def main():
    tx = Treasury.deploy(BUSD_ADDRESS, {"from": ACCOUNT})
    tx1 = Charity.deploy(BUSD_ADDRESS, {"from": ACCOUNT})
    tx2 = Dev.deploy(BUSD_ADDRESS, {"from": ACCOUNT})
