from brownie import (
    Presale,
)
from scripts.helpful_scripts import get_account
from web3 import Web3


def openSale():
    account = get_account()
    presale = Presale[-1]
    tx = presale.openPresale({"from": account})
    tx.wait(1)


def main():
    openSale()
