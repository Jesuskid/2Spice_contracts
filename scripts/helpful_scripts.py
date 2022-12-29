from brownie import (
    accounts,
    config,
    network,
    Contract,
)

FORKED_LOCAL_ENV = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHIANS_ENV = ["development", "ganache-local"]
DECIMALS = 8
STARTING_PRICE = 2000000000000000000000


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHIANS_ENV
        or network.show_active() in FORKED_LOCAL_ENV
    ):
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def get_account2(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHIANS_ENV
        or network.show_active() in FORKED_LOCAL_ENV
    ):
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["test_key"])



BUSD_ADDRESS = '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56'
ROUTER_ADDRESS = '0x10ED43C718714eb63d5aA57B78B54704E256024E'
OWNER_ADDRESS = '0x9f5d865390ea7cb9a7bb581e67fa07f9c10722f1'