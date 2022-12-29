##deploys charity, treasury and devAndMarketing wallets
from brownie import (
    Spice,
    GameReward,
)
from scripts.helpful_scripts import get_account, OWNER_ADDRESS, BUSD_ADDRESS, ROUTER_ADDRESS
from web3 import Web3
import time

BUSD_ADDRESS = BUSD_ADDRESS
ACCOUNT = get_account()
spice = Spice[-1]
router = ROUTER_ADDRESS
OWNER = OWNER_ADDRESS

print(OWNER_ADDRESS)
def setRewardInSpice(rewardContractAddress):
    tx = spice.setRewardContract(rewardContractAddress, {"from": ACCOUNT})
    tx.wait(1)

def main():
    print(OWNER_ADDRESS)
    gReward = GameReward.deploy(spice.address, OWNER_ADDRESS, {"from": ACCOUNT})
    setRewardInSpice(gReward.address)
    print(spice.balanceOf(gReward))

