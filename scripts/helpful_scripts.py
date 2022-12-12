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



BUSD_ADDRESS = ''
ROUTER_ADDRESS = ''
OWNER_ADDRESS = ''