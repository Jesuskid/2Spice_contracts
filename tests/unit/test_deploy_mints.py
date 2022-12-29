## TODO: check iP fees collected is correct
from scripts.dev_local.deploy import deploy_Contracts
from scripts.helpful_scripts import get_account
from brownie import accounts
from web3 import Web3

def test_purchase():
    #Arrange
    account = accounts[1]
    spice, dappToken = deploy_Contracts()
    prev_balance = spice.balanceOf(account)

    amt = Web3.toWei(100000, 'ether')
    tx3 = spice.collectBuyFees(amt, account, {'from': account})
    tx3.wait(1)
    amt = tx3.return_value
    print(amt)
    

    #act
    tx1 = dappToken.approve(spice.address, Web3.toWei(1000000, 'ether'), {'from':account})
    tx1.wait(1)
    tx2 = spice.purchaseFromThis(Web3.toWei(100000, 'ether'), {'from': account})
    tx2.wait(1)
    print("purchase successfully")

    new_balance = spice.balanceOf(account)
   
    #assert
    assert prev_balance < new_balance
    assert prev_balance+amt == new_balance

    # tx2 = spice.sellToThis(Web3.toWei(10000, 'ether'), {'from': account})
    # tx2.wait(1)
    
    
