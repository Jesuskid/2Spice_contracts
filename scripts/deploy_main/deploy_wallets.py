##deploys charity, treasury and devAndMarketing wallets
from brownie import (
    Charity,
    Dev,
    Treasury,
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import helpful_scripts

BUSD_ADDRESS = helpful_scripts.BUSD_ADDRESS
ACCOUNT = get_account()
ADMIN = ''

#deploy wallets to the binance smart chain
def main():
    tx = Treasury.deploy(BUSD_ADDRESS, ADMIN, {"from": ACCOUNT})
    tx1 = Charity.deploy(BUSD_ADDRESS, ADMIN, {"from": ACCOUNT})
    tx2 = Dev.deploy(BUSD_ADDRESS, ADMIN, {"from": ACCOUNT})
