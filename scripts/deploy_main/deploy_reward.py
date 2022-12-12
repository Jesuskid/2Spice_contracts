##deploys charity, treasury and devAndMarketing wallets
from brownie import (
    Spice,
    GameReward
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import time
import helpful_scripts

BUSD_ADDRESS = helpful_scripts.BUSD_ADDRESS
ACCOUNT = get_account()
spice = Spice[-1]
router = helpful_scripts.ROUTER_ADDRESS

def setRewardInSpice(rewardContractAddress):
    tx = spice.setRewardContract(rewardContractAddress, {"from", ACCOUNT})
    tx.wait(1)

def main():
    gReward = GameReward.deploy(spice.address, router, BUSD_ADDRESS, {"from": ACCOUNT})
    setRewardInSpice(gReward.address)

