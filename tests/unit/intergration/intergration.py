from brownie import (
    accounts,
    config,
    network,
    Spice,
    interface,
)
from scripts.helpful_scripts import get_account
from web3 import Web3
from scripts.deploy_bsctestnet import deploy_Contracts, latest_contract
import time

# # presale tests


def test_presaleOpens():
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    # arrange
    spiceContract = latest_contract()
    spiceContract.openPresale({"from": ACCOUNT, "gas_limit": 2100000})

    # act
    open = spiceContract.presaleOpen()
    timer = spiceContract.presaleTimer()

    # assert
    assert open == True
    assert timer > 0
    time.sleep(2)


def test_presale():
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    # arrange

    spiceContract = latest_contract()
    initial_balance = BUSD_CONTRACT.balanceOf(spiceContract.address)
    # act
    BUSD_CONTRACT.approve(
        spiceContract.address, ONE_ETHER, {"from": ACCOUNT, "gas_limit": 2100000}
    )
    spiceContract.presale(ONE_ETHER, {"from": ACCOUNT, "gas_limit": 2100000})
    # assert
    assert BUSD_CONTRACT.balanceOf(spiceContract.address) > initial_balance
    print("presale successful")
    time.sleep(140)


def test_withdraw():
    # arrange
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    spiceContract = latest_contract()
    initial_balance = BUSD_CONTRACT.balanceOf(spiceContract.address)
    # act
    spiceContract.openContractAndWithdrawPresale(
        {"from": ACCOUNT, "gas_limit": 2100000}
    )
    # assert
    assert BUSD_CONTRACT.balanceOf(spiceContract.address) == ONE_ETHER


def test_purchase():
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    # arrange
    spiceContract = latest_contract()
    BUSD_CONTRACT.approve(
        spiceContract.address, ONE_ETHER, {"from": ACCOUNT, "gas_limit": 2100000}
    )
    initial_balance = BUSD_CONTRACT.balanceOf(ACCOUNT)
    print(initial_balance)
    # act
    spiceContract.purchaseFromThis(ONE_ETHER, {"from": ACCOUNT, "gas_limit": 2100000})
    # assert
    assert initial_balance > BUSD_CONTRACT.balanceOf(ACCOUNT)


def test_sell():
    # arrange
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    spiceContract = latest_contract()
    initial_balance = BUSD_CONTRACT.balanceOf(ACCOUNT)
    # act
    spiceContract.sellToThis(ONE_ETHER, {"from": ACCOUNT, "gas_limit": 2100000})
    # assert
    assert initial_balance < BUSD_CONTRACT.balanceOf(ACCOUNT)


# def test_swap_fees():
#     ACCOUNT = get_account()
#     TWO_ETHER = Web3.toWei(1, "ether")
#     BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
#     BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
#     spiceContract = latest_contract()
#     initial_balance = spiceContract.balanceOf(spiceContract.address)

#     tx = spiceContract._swapAndTransferFees(False, TWO_ETHER, {"from": ACCOUNT})
#     tx.wait(1)

#     assert initial_balance > spiceContract.balanceOf(spiceContract.address)
