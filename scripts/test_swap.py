##imports
from brownie import (
    accounts,
    config,
    network,
    Spice,
    interface,
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import time
import datetime
import calendar


C_ADDRESS = "0x6860292e4De0bc5653faf3C6bFC9bC5F8A787Db6"

##Immutable Variables
OWNER_ADDRESS = "0x8478F8c1d693aB4C054d3BBC0aBff4178b8F1b0B"
BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
LP_ADDRESS = "0x73cbD24A5EfB81dDe6bbA03c781b8d096415C9eC"
router = "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3"
Router = interface.IPancakeRouter02(router)
LP = interface.ILP("0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3")
##real busd "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
##----------------------objectives
charity = "0x2311f6e7E8550a867a0008830004B017B6fe6376"


def test_swap():
    account = get_account()
    # arrange
    spice = Spice[-1]
    one_ether = Web3.toWei(0.001, "ether")
    ten_ether = Web3.toWei(1000, "ether")
    # tx = interface.IERC20(spice.address).transfer(
    #     LP_ADDRESS, ten_ether, {"from": account}
    # )
    # tx.wait(1)
    # tx1 = LP.swap(one_ether, account, {"from": account, 'gas_limit': 210000})
    # tx1.wait(1)
    print(spice.balanceOf(spice.address))
    tx2 = spice._swapSpiceForBusd(
        one_ether,
        charity,
        {"from": account, "gas_limit": 2100000},
    )
    tx2.wait(1)


def test_spice_swap():
    account = get_account()
    # arrange
    path2 = [C_ADDRESS, BUSD_ADDRESS]
    one_ether = Web3.toWei(1, "ether")

    future = datetime.datetime.utcnow() + datetime.timedelta(minutes=5)
    now = calendar.timegm(future.timetuple())

    tx = Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
        one_ether,
        0,
        path2,
        account,
        now,
        {"from": account, "gas_limit": 2100000},
    )
    tx.wait(1)

    print("swap successful")


def main():
    test_swap()
