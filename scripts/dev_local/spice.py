import imp
from brownie import accounts, config, network, Spice, interface, Contract
from brownie.network import priority_fee
from scripts.helpful_scripts import get_account
from web3 import Web3
import time
import datetime
import calendar

##Immutable Variables
C_ADDRESS = "0x631E1bF81438DDE277654a3414D3D2B9f48cCEB1"
BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
router = interface.ISpice("0x631E1bF81438DDE277654a3414D3D2B9f48cCEB1")


def main():
    account = get_account()
    print(account)

    path = [C_ADDRESS, BUSD_ADDRESS]

    path2 = [BUSD_ADDRESS, C_ADDRESS]
    one_ether = Web3.toWei(1, "ether")

    future = datetime.datetime.utcnow() + datetime.timedelta(minutes=5)
    now = calendar.timegm(future.timetuple())

    tx2 = router._swapSpiceForBusd(
        one_ether,
        account,
        {"from": account, "gas_limit": 2100000},
    )
    tx2.wait(1)

    print(tx2)
