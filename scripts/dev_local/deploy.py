##imports
from brownie import (
    accounts,
    config,
    network,
    Spice,
    SpiceLiquidityHandler,
    interface,
    DappToken
)
import datetime
import calendar
from scripts.helpful_scripts import get_account
from web3 import Web3
import time

##Immutable Variables
BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
ROUTER = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"

##real busd "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56"
##----------------------objectives
charity = "0x2311f6e7E8550a867a0008830004B017B6fe6376"

def deploy_token():
   dappToken =  DappToken.deploy({'from': accounts[0]})
    

def deploy_Contracts():
    OWNER_ADDRESS = accounts[0]
    account = get_account()
    ##set up
    dappToken =  DappToken.deploy({'from': account})
    dappToken = DappToken[-1]
    spice = Spice.deploy(dappToken.address, ROUTER, OWNER_ADDRESS, {"from": account})
    print("deployed spice successfully")
    tx = dappToken.transfer(accounts[1], Web3.toWei(1000000, 'ether'))
    tx.wait(1)
    tx1 = dappToken.approve(spice.address, Web3.toWei(1000000, 'ether'), {'from':account})
    tx1.wait(1)
    print(f"old price {spice.calculatePrice()}")
    tx2 = spice.purchaseFromThis(Web3.toWei(100000, 'ether'), {'from': account})
    tx2.wait(1)
    print(f'bought {spice.balanceOf(account)}')
    print(f"new price {spice.calculatePrice()}")
    print(f"total supply {spice.totalSupply()}")

    tx2 = spice.sellToThis(Web3.toWei(10000, 'ether'), {'from': account})
    tx2.wait(1)
    print(f"new balance {spice.balanceOf(account)}")
    print(f"new price {spice.calculatePrice()}")
    set_fee_wallets(spice)
    addLiq(spice)
    return (spice, dappToken)


def latest_contract():
    return Spice[-1]

def latest_token():
    return DappToken[-1]



def addLiq(spice):
    router = interface.IPancakeRouter02("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D")
    BUSD_ADDRESS = DappToken[-1]
    account = get_account()
    # arrange
  
    one_ether = Web3.toWei(100, "ether")
    one_thousand_ether = Web3.toWei(1000, "ether")

    tx00 = spice.approve(
        ROUTER, one_thousand_ether, {"from": account, "gas_limit": 2100000}
    )
    tx00.wait(1)

    tx01 = interface.IERC20(BUSD_ADDRESS).approve(
        ROUTER, one_thousand_ether, {"from": account, "gas_limit": 2100000}
    )
    tx01.wait(1)
    # tx = router.getAmountsOut.call(Web3.toWei(1, "ether"), path2)
    # print(Web3.fromWei(tx[1], "ether"))
    timestamp = int(time.time()+300) 
    tx3 = router.addLiquidity(spice.address,BUSD_ADDRESS, one_thousand_ether, one_thousand_ether, 0, 0,
        account,
        timestamp,
        {'from': account}
    )
    tx3.wait(1)


  
def set_fee_wallets(spice):
    account = get_account()
    tx = spice.setFeeReceivers(
        account, account, account, account, {"from": account}
    )
    tx.wait(1)


def test_swap():
    router = interface.IPancakeRouter02("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D")
    account = accounts[1]
    BUSD_ADDRESS = DappToken[-1]
    C_ADDRESS = Spice[-1]
 
    path = [BUSD_ADDRESS, C_ADDRESS.address]

    path2 = [C_ADDRESS.address, BUSD_ADDRESS]
    one_ether = Web3.toWei(10, "ether")
    two_ether = Web3.toWei(20, "ether")

    spBefore = C_ADDRESS.balanceOf.call(C_ADDRESS.address)
    feeCollectedB = C_ADDRESS.feeCollectedSpice()

    future = datetime.datetime.utcnow() + datetime.timedelta(minutes=5)
    now = calendar.timegm(future.timetuple())
    tx0 = C_ADDRESS.approve(
        ROUTER, Web3.toWei(200000, "ether"), {"from": account, "gas_limit": 2100000}
    )
    tx0.wait(1)



    tx01 = interface.IERC20(BUSD_ADDRESS).approve(
        ROUTER, Web3.toWei(200000, "ether"), {"from": account, "gas_limit": 2100000}
    )
    tx01.wait(1)
    # tx = router.getAmountsOut.call(Web3.toWei(1, "ether"), path2)
    # print(Web3.fromWei(tx[1], "ether"))
    tx2 = router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
        two_ether, 0, path, account, now, {"from": account, "gas_limit": 2100000}
    )
    tx2.wait(1)

    tx3 = router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
        one_ether, 0, path2, account, now, {"from": account, "gas_limit": 2100000}
    )
    tx3.wait(1)

    # tx4 = C_ADDRESS.transferFrom(account, account, one_ether, {"from": account})
    # tx4.wait(1)

    feeCollected = C_ADDRESS.feeCollectedSpice()
    
    print("swap successful")
    print(f"fee collected spice {feeCollectedB,feeCollected}")

    spAfter = C_ADDRESS.balanceOf.call(C_ADDRESS.address)

    # print(tx2)
    print(Web3.fromWei(spBefore, "ether"), Web3.fromWei(spAfter, "ether"))

    
def getPrices():
    spice = Spice[-1]
    pricePCS = spice.fetchPCSPrice()
    priceInternal = spice.calculatePrice()
    print(pricePCS)
    print(priceInternal)

def transfer():
    spice = Spice[-1]
    tx3 = spice.transfer(accounts[1], Web3.toWei(10, 'ether'), {'from': accounts[1]})
    tx3.wait(1)
    feeCollected = spice.feeCollectedSpice()

    
    print("transfer correct")
    print(f"fee collected in spice {feeCollected}")

def main():
    deploy_Contracts()
    test_swap()
    getPrices()
    test_swap()
    getPrices()
    transfer()