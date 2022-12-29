##deploys charity, treasury and devAndMarketing wallets
from brownie import (
    Charity,
    Dev,
    Treasury,
)
from scripts.helpful_scripts import get_account, BUSD_ADDRESS, OWNER_ADDRESS
from web3 import Web3
import scripts.helpful_scripts

BUSD_ADDRESS = BUSD_ADDRESS
ACCOUNT = get_account()
ADMIN = OWNER_ADDRESS

#deploy wallets to the binance smart chain
def main():
    tx = Treasury.deploy(BUSD_ADDRESS, ADMIN, {"from": ACCOUNT})
    tx1 = Charity.deploy(BUSD_ADDRESS, ADMIN, {"from": ACCOUNT})
    tx2 = Dev.deploy(BUSD_ADDRESS, ADMIN, {"from": ACCOUNT})
